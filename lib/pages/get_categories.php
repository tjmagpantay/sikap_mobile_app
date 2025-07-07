<?php
// filepath: c:\xampp\htdocs\sikap_api\php\get_categories.php
require_once '../config/cors-headers.php'; // Use same filename as get_jobpost.php
require_once '../config/db_config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit;
}

try {
    if (!$conn) {
        throw new Exception('Database connection failed');
    }

    // Use mysqli (same as get_jobpost.php) and correct table name
    $sql = "
        SELECT 
            jc.job_category_id as category_id,
            jc.category_name,
            COUNT(jp.job_id) as job_count
        FROM job_category jc
        LEFT JOIN job_post jp ON jc.job_category_id = jp.job_category_id 
            AND jp.job_status = 'open'
        GROUP BY jc.job_category_id, jc.category_name
        ORDER BY jc.category_name ASC
    ";

    $result = $conn->query($sql);

    if (!$result) {
        throw new Exception("Query failed: " . $conn->error);
    }

    $categories = [];
    while ($row = $result->fetch_assoc()) {
        $categories[] = [
            'category_id' => (int)$row['category_id'],
            'category_name' => $row['category_name'],
            'job_count' => (int)$row['job_count']
        ];
    }

    echo json_encode([
        'success' => true,
        'categories' => $categories,
        'total_categories' => count($categories),
        'message' => count($categories) > 0 ? 'Categories loaded successfully' : 'No categories found'
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $e->getMessage(),
        'categories' => []
    ]);
    error_log("Categories API Error: " . $e->getMessage());
}

$conn->close();
