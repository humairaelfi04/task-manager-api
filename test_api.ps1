Write-Host "`n=== TEST 1: POST - Create Task 1 ==="
$task1 = Invoke-RestMethod -Uri 'http://localhost:8080/api/tasks' -Method Post -ContentType 'application/json; charset=utf-8' -InFile 'test_task1.json'
$task1 | ConvertTo-Json -Depth 5
$id1 = $task1.id

Write-Host "`n=== TEST 2: POST - Create Task 2 ==="
$task2 = Invoke-RestMethod -Uri 'http://localhost:8080/api/tasks' -Method Post -ContentType 'application/json; charset=utf-8' -InFile 'test_task2.json'
$task2 | ConvertTo-Json -Depth 5
$id2 = $task2.id

Write-Host "`n=== TEST 3: GET ALL TASKS ==="
$all = Invoke-RestMethod -Uri 'http://localhost:8080/api/tasks' -Method Get
Write-Host "Total tasks: $($all.Count)"
$all | ConvertTo-Json -Depth 5

Write-Host "`n=== TEST 4: GET TASK BY ID ($id2) ==="
$single = Invoke-RestMethod -Uri "http://localhost:8080/api/tasks/$id2" -Method Get
$single | ConvertTo-Json -Depth 5

Write-Host "`n=== TEST 5: PUT - Update Task ($id2) ==="
$updated = Invoke-RestMethod -Uri "http://localhost:8080/api/tasks/$id2" -Method Put -ContentType 'application/json; charset=utf-8' -InFile 'test_update.json'
$updated | ConvertTo-Json -Depth 5

Write-Host "`n=== TEST 6: GET TASK BY ID ($id2) - Verify Update ==="
$verify = Invoke-RestMethod -Uri "http://localhost:8080/api/tasks/$id2" -Method Get
$verify | ConvertTo-Json -Depth 5

Write-Host "`n=== TEST 7: DELETE TASK ($id1) ==="
try {
    Invoke-RestMethod -Uri "http://localhost:8080/api/tasks/$id1" -Method Delete
    Write-Host "DELETE successful (HTTP 204 No Content)"
} catch {
    Write-Host "DELETE response: $($_.Exception.Message)"
}

Write-Host "`n=== TEST 8: GET ALL TASKS (After Delete) ==="
$remaining = Invoke-RestMethod -Uri 'http://localhost:8080/api/tasks' -Method Get
Write-Host "Remaining tasks: $($remaining.Count)"
$remaining | ConvertTo-Json -Depth 5

Write-Host "`n=== TEST 9: GET DELETED TASK ($id1) - Should Return 404 ==="
try {
    Invoke-RestMethod -Uri "http://localhost:8080/api/tasks/$id1" -Method Get
    Write-Host "ERROR: Task should have been deleted!"
} catch {
    Write-Host "PASS: Got expected 404 Not Found"
}

Write-Host "`n=== ALL TESTS COMPLETED ==="
