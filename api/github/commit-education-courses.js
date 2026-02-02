/**
 * Vercel Serverless Function - GitHub Auto-Commit for Education Courses
 * Endpoint: /api/github/commit-education-courses
 * 
 * This function automatically commits education tab courses to GitHub
 * Called by the admin panel when education courses are saved
 * Version: 1.0.1
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
 * Get the current education content file from GitHub
 */
async function getCurrentEducationContentFile() {
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
    throw new Error(`Failed to get current education content: ${error.message}`);
  }
}

/**
 * Generate Dart code from education courses JSON - only the EducationTabCourse section
 */
function generateEducationTabCoursesCode(coursesJson, existingFileContent) {
  let courses = Array.isArray(coursesJson) ? coursesJson : JSON.parse(coursesJson);

  // Build course list
  let coursesList = '';
  courses.forEach((course, index) => {
    if (index > 0) coursesList += ',\n      ';

    // Build features list
    let features = '';
    if (course.features && course.features.length > 0) {
      features = course.features.map(f => `'${f.replace(/'/g, "\\'")}'`).join(',\n        ');
    }

    // Build topics list
    let topics = '';
    if (course.topics && course.topics.length > 0) {
      topics = course.topics.map(t => `'${t.replace(/'/g, "\\'")}'`).join(',\n        ');
    }

    coursesList += `EducationTabCourse(
      id: '${course.id.replace(/'/g, "\\'")}',
      title: '${course.title.replace(/'/g, "\\'")}',
      description: '${course.description.replace(/'/g, "\\'")}',
      icon: '${course.icon.replace(/'/g, "\\'")}',
      color: '${course.color.replace(/'/g, "\\'")}',
      price: ${course.price},
      duration: '${course.duration.replace(/'/g, "\\'")}',
      features: [
        ${features}
      ],
      details: '${course.details.replace(/'/g, "\\'")}',
      topics: [
        ${topics}
      ],
    )`;
  });

  // If there's existing content, try to preserve other classes
  if (existingFileContent) {
    // Find the EducationTabCourse class start and end
    const educationTabStart = existingFileContent.indexOf('class EducationTabCourse');
    
    if (educationTabStart !== -1) {
      // Keep everything before EducationTabCourse
      const beforeClass = existingFileContent.substring(0, educationTabStart);
      
      // Find where EducationTabCourse class ends (look for the next top-level class or end of file)
      const afterClassStart = existingFileContent.indexOf('\nclass ', educationTabStart + 10);
      const afterClass = afterClassStart !== -1 ? existingFileContent.substring(afterClassStart) : '';
      
      // Generate the new EducationTabCourse class
      const newClassCode = `class EducationTabCourse {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String color;
  final int price;
  final String duration;
  final List<String> features;
  final String details;
  final List<String> topics;

  EducationTabCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.price,
    required this.duration,
    required this.features,
    required this.details,
    required this.topics,
  });

  factory EducationTabCourse.defaultCourses() {
    return EducationTabCourse.fromJson({});
  }

  static List<EducationTabCourse> defaultCourses() {
    return [
      ${coursesList}
    ];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'icon': icon,
    'color': color,
    'price': price,
    'duration': duration,
    'features': features,
    'details': details,
    'topics': topics,
  };

  factory EducationTabCourse.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return EducationTabCourse(
        id: '',
        title: '',
        description: '',
        icon: '',
        color: 'blue',
        price: 0,
        duration: '',
        features: [],
        details: '',
        topics: [],
      );
    }
    return EducationTabCourse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? 'blue',
      price: json['price'] ?? 0,
      duration: json['duration'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      details: json['details'] ?? '',
      topics: List<String>.from(json['topics'] ?? []),
    );
  }
}

`;
      
      return beforeClass + newClassCode + afterClass;
    }
  }

  // Fallback: generate complete file (should not happen if file exists)
  return `import 'dart:convert';

// Education tab course data structure
class EducationTabCourse {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String color;
  final int price;
  final String duration;
  final List<String> features;
  final String details;
  final List<String> topics;

  EducationTabCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.price,
    required this.duration,
    required this.features,
    required this.details,
    required this.topics,
  });

  factory EducationTabCourse.defaultCourses() {
    return EducationTabCourse.fromJson({});
  }

  static List<EducationTabCourse> defaultCourses() {
    return [
      ${coursesList}
    ];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'icon': icon,
    'color': color,
    'price': price,
    'duration': duration,
    'features': features,
    'details': details,
    'topics': topics,
  };

  factory EducationTabCourse.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return EducationTabCourse(
        id: '',
        title: '',
        description: '',
        icon: '',
        color: 'blue',
        price: 0,
        duration: '',
        features: [],
        details: '',
        topics: [],
      );
    }
    return EducationTabCourse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? 'blue',
      price: json['price'] ?? 0,
      duration: json['duration'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      details: json['details'] ?? '',
      topics: List<String>.from(json['topics'] ?? []),
    );
  }
}
`;
}

/**
 * Create/update the education courses in GitHub
 */
async function commitEducationCoursesFile(dartContent, message, sha) {
  try {
    const encodedContent = Buffer.from(dartContent).toString('base64');

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
    throw new Error(`Failed to commit education courses: ${error.message}`);
  }
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

    // Get courses from request
    const { courses, message, courseCount } = req.body;

    if (!courses || !Array.isArray(courses)) {
      return res.status(400).json({ error: 'Courses array is required' });
    }

    console.log(`📚 Processing ${courseCount || courses.length} education courses...`);

    // Get current file SHA and content
    console.log('Fetching current file from GitHub...');
    const currentFile = await getCurrentEducationContentFile();

    // Generate Dart code from courses, preserving existing content
    console.log('Generating Dart code for education tab courses...');
    const dartContent = generateEducationTabCoursesCode(courses, currentFile.content);

    // Commit to GitHub
    console.log('Committing education courses to GitHub...');
    const commitMessage = message || '📚 Update education tab courses from admin panel';
    const commitResponse = await commitEducationCoursesFile(
      dartContent,
      commitMessage,
      currentFile.sha
    );

    console.log('Education courses commit successful:', commitResponse.commit.sha);

    return res.status(200).json({
      success: true,
      message: 'Education courses committed to GitHub successfully',
      commitSha: commitResponse.commit.sha,
      commitUrl: commitResponse.html_url,
    });
  } catch (error) {
    console.error('❌ Error committing education courses:', error);
    return res.status(500).json({
      error: error.message || 'Failed to commit education courses to GitHub',
    });
  }
}
