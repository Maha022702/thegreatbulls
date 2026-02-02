/**
 * Vercel Serverless Function - GitHub Auto-Commit for Education Content
 * Endpoint: /api/github/commit-education-content
 * 
 * This function automatically commits education content changes to GitHub
 * Called by the admin panel when content is saved
 */

const https = require('https');

/**
 * Make HTTPS request to GitHub API
 */
function makeGithubRequest(method, path, data = null) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'api.github.com',
      port: 443,
      path: path,
      method: method,
      headers: {
        'Authorization': `token ${process.env.GITHUB_TOKEN}`,
        'User-Agent': 'The Great Bulls Admin Panel',
        'Content-Type': 'application/json',
        'Accept': 'application/vnd.github.v3+json',
      },
    };

    const req = https.request(options, (res) => {
      let body = '';

      res.on('data', (chunk) => {
        body += chunk;
      });

      res.on('end', () => {
        try {
          const response = JSON.parse(body);
          if (res.statusCode >= 400) {
            reject(new Error(`GitHub API Error: ${res.statusCode} - ${response.message}`));
          } else {
            resolve(response);
          }
        } catch (e) {
          reject(new Error(`Failed to parse GitHub response: ${e.message}`));
        }
      });
    });

    req.on('error', (e) => {
      reject(new Error(`Request failed: ${e.message}`));
    });

    if (data) {
      req.write(JSON.stringify(data));
    }

    req.end();
  });
}

/**
 * Get the current content file from GitHub
 */
async function getCurrentContentFile() {
  try {
    const response = await makeGithubRequest(
      'GET',
      '/repos/Maha022702/thegreatbulls/contents/lib/education_content.dart'
    );
    return {
      sha: response.sha,
      content: Buffer.from(response.content, 'base64').toString('utf-8'),
    };
  } catch (error) {
    throw new Error(`Failed to get current content: ${error.message}`);
  }
}

/**
 * Create/update the content file on GitHub
 */
async function commitContentFile(content, message, sha) {
  try {
    const encodedContent = Buffer.from(content).toString('base64');

    const data = {
      message: message,
      content: encodedContent,
      sha: sha,
      branch: 'main',
      committer: {
        name: 'The Great Bulls Admin',
        email: 'admin@thegreatbulls.in',
      },
    };

    const response = await makeGithubRequest(
      'PUT',
      '/repos/Maha022702/thegreatbulls/contents/lib/education_content.dart',
      data
    );

    return response;
  } catch (error) {
    throw new Error(`Failed to commit content: ${error.message}`);
  }
}

/**
 * Generate Dart code from JSON education content
 */
function generateDartContent(jsonContent) {
  const json = JSON.parse(jsonContent);

  // Build feature sections
  let featureSections = '';
  json.featureSections.forEach((section, index) => {
    if (index > 0) featureSections += ',\n        ';
    
    let features = '';
    section.features.forEach((feature, fIndex) => {
      if (fIndex > 0) features += ',\n              ';
      features += `Feature(
              icon: '${feature.icon}',
              title: '${feature.title.replace(/'/g, "\\'")}',
              description: '${feature.description.replace(/'/g, "\\'")}',
              detail: '${feature.detail.replace(/'/g, "\\'")}',
              color: '${feature.color}',
            )`;
    });

    featureSections += `FeatureSection(
          title: '${section.title.replace(/'/g, "\\'")}',
          features: [
            ${features}
          ],
        )`;
  });

  const dartCode = `import 'dart:convert';

// Education content data structure
class EducationContent {
  final String heroTitle;
  final String heroSubtitle;
  final String eliteValueText;
  final String eliteValueDescription;
  final List<FeatureSection> featureSections;

  EducationContent({
    required this.heroTitle,
    required this.heroSubtitle,
    required this.eliteValueText,
    required this.eliteValueDescription,
    required this.featureSections,
  });

  factory EducationContent.defaultContent() {
    return EducationContent(
      heroTitle: '${json.heroTitle.replace(/'/g, "\\'")}',
      heroSubtitle: '${json.heroSubtitle.replace(/'/g, "\\'")}',
      eliteValueText: '${json.eliteValueText.replace(/'/g, "\\'")}',
      eliteValueDescription: '${json.eliteValueDescription.replace(/'/g, "\\'")}',
      featureSections: [
        ${featureSections}
      ],
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() => {
    'heroTitle': heroTitle,
    'heroSubtitle': heroSubtitle,
    'eliteValueText': eliteValueText,
    'eliteValueDescription': eliteValueDescription,
    'featureSections': featureSections.map((s) => s.toJson()).toList(),
  };

  factory EducationContent.fromJson(Map<String, dynamic> json) {
    return EducationContent(
      heroTitle: json['heroTitle'] ?? '',
      heroSubtitle: json['heroSubtitle'] ?? '',
      eliteValueText: json['eliteValueText'] ?? '',
      eliteValueDescription: json['eliteValueDescription'] ?? '',
      featureSections: (json['featureSections'] as List?)
          ?.map((s) => FeatureSection.fromJson(s))
          .toList() ?? [],
    );
  }
}

class FeatureSection {
  final String title;
  final List<Feature> features;

  FeatureSection({
    required this.title,
    required this.features,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'features': features.map((f) => f.toJson()).toList(),
  };

  factory FeatureSection.fromJson(Map<String, dynamic> json) {
    return FeatureSection(
      title: json['title'] ?? '',
      features: (json['features'] as List?)
          ?.map((f) => Feature.fromJson(f))
          .toList() ?? [],
    );
  }
}

class Feature {
  final String icon;
  final String title;
  final String description;
  final String detail;
  final String color;

  Feature({
    required this.icon,
    required this.title,
    required this.description,
    required this.detail,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
    'icon': icon,
    'title': title,
    'description': description,
    'detail': detail,
    'color': color,
  };

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      icon: json['icon'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      detail: json['detail'] ?? '',
      color: json['color'] ?? 'blue',
    );
  }
}
`;

  return dartCode;
}

/**
 * Main handler
 */
export default async function handler(req, res) {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Credentials', 'true');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
  res.setHeader('Access-Control-Allow-Headers', 'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // Only allow POST requests
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    // Verify authentication token
    const adminToken = req.headers['x-admin-token'];
    const envToken = process.env.ADMIN_TOKEN;
    
    console.log('🔍 DEBUG: Received X-Admin-Token header:', adminToken ? adminToken.substring(0, 10) + '...' : 'MISSING');
    console.log('🔍 DEBUG: Expected ADMIN_TOKEN env:', envToken ? envToken.substring(0, 10) + '...' : 'MISSING');
    console.log('🔍 DEBUG: Token match:', adminToken === envToken);
    
    if (adminToken !== envToken) {
      console.log('❌ Token mismatch - Unauthorized');
      return res.status(401).json({ error: 'Unauthorized - Invalid admin token' });
    }

    // Get content from request
    const { content, message } = req.body;

    if (!content) {
      return res.status(400).json({ error: 'Content is required' });
    }

    // Validate content is valid JSON
    try {
      JSON.parse(content);
    } catch (e) {
      return res.status(400).json({ error: 'Invalid content JSON' });
    }

    // Get current file SHA
    console.log('Fetching current file from GitHub...');
    const currentFile = await getCurrentContentFile();

    // Generate Dart code from content
    console.log('Generating Dart code...');
    const dartContent = generateDartContent(content);

    // Commit to GitHub
    console.log('Committing to GitHub...');
    const commitMessage = message || '📚 Update education content from admin panel';
    const commitResponse = await commitContentFile(
      dartContent,
      commitMessage,
      currentFile.sha
    );

    console.log('Commit successful:', commitResponse.commit.sha);

    return res.status(200).json({
      success: true,
      message: 'Content committed to GitHub successfully',
      commitSha: commitResponse.commit.sha,
      commitUrl: commitResponse.html_url,
    });
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({
      error: error.message || 'Failed to commit content to GitHub',
    });
  }
}
