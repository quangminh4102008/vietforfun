<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Course Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-100">
<div class="container mx-auto px-4 py-8">
    <div class="flex justify-between items-center mb-6">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">Course Management</h1>
            <p class="text-gray-500">Manage your courses here</p>
        </div>
        <button onclick="document.getElementById('courseFormContainer').classList.remove('hidden')" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
            <i class="fas fa-plus mr-2"></i> Add Course
        </button>
    </div>
    <!--  Search + Filter Bar -->
    <div class="bg-white rounded-lg shadow p-4 mb-6 flex flex-col md:flex-row gap-4">
        <input type="text" id="searchInput" placeholder="Search title or description..."
               class="flex-1 px-4 py-2 border border-gray-300 rounded"/>

        <select id="levelFilter" class="px-4 py-2 border border-gray-300 rounded">
            <option value="">All Levels</option>
            <option value="Beginner">Beginner</option>
            <option value="Intermediate">Intermediate</option>
            <option value="Advanced">Advanced</option>
        </select>

        <select id="statusFilter" class="px-4 py-2 border border-gray-300 rounded">
            <option value="">All Statuses</option>
            <option value="active">Active</option>
            <option value="deleted">Deleted</option>
        </select>
    </div>
    <!-- Table -->
    <div class="bg-white shadow rounded overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
            <tr>
                <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Title</th>
                <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Description</th>
                <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Level</th>
                <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Status</th>
                <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Published</th>
                <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Actions</th>
            </tr>
            </thead>

            <tbody id="courseTableBody" class="bg-white divide-y divide-gray-200">
            <c:forEach var="course" items="${courses}">
                <tr class="course-row">
                    <td class="px-6 py-4 course-title">${course.title}</td>
                    <td class="px-6 py-4 course-description">${course.description}</td>
                    <td class="px-6 py-4 course-level">${course.level}</td>
                    <td class="px-6 py-4 course-status">${course.status}</td>
                    <td class="px-6 py-4">${course.published ? "Yes" : "No"}</td>
                    <td class="px-6 py-4">
                        <form action="course" method="post" class="inline">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${course.id}">
                            <button type="submit" class="text-red-600 hover:text-red-800">
                                <i class="fas fa-trash"></i>
                            </button>
                        </form>
                        <button onclick="editCourse(
                                '${course.id}',
                                '${fn:escapeXml(course.title)}',
                                '${fn:escapeXml(course.description)}',
                                '${course.level}',
                                '${course.status}',
                            ${course.published},
                                '${fn:escapeXml(course.thumbnailUrl)}'
                                )"
                                class="ml-4 text-blue-600 hover:text-blue-800">
                            <i class="fas fa-edit"></i>
                        </button>
                    </td>
                    <td>
                        <!-- Nút quản lý câu hỏi -->
                        <a href="questions?courseId=${course.id}" class="text-blue-600 hover:underline flex items-center gap-1">
                            <i class="fas fa-question-circle"></i> Manage Questions
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>


    <!-- Add/Edit Form -->
    <div id="courseFormContainer" class="hidden mt-8 bg-white p-6 rounded shadow">
        <form action="course" method="post">
            <input type="hidden" name="action" value="add" id="formAction">
            <input type="hidden" name="id" id="courseId">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block mb-1 font-semibold">Title</label>
                    <input type="text" name="title" id="titleInput" required class="w-full border px-3 py-2 rounded" />
                </div>
                <div class="col-span-2">
                    <label class="block mb-1 font-semibold">Description</label>
                    <textarea name="description" id="descriptionInput" required class="w-full border px-3 py-2 rounded"></textarea>
                </div>
                <div>
                    <label class="block mb-1 font-semibold">Level</label>
                    <select name="level" id="levelInput" required class="w-full border px-3 py-2 rounded">
                        <option value="Beginner">Beginner</option>
                        <option value="Intermediate">Intermediate</option>
                        <option value="Advanced">Advanced</option>
                    </select>
                </div>
                <div>
                    <label class="block mb-1 font-semibold">Status</label>
                    <select name="status" id="statusInput" required class="w-full border px-3 py-2 rounded">
                        <option value="active">Active</option>
                        <option value="deleted">Deleted</option>
                    </select>
                </div>
                <div>
                    <label class="block mb-1 font-semibold">Thumbnail URL</label>
                    <input type="text" name="thumbnailUrl" id="thumbnailInput" class="w-full border px-3 py-2 rounded" />
                </div>
            </div>
            <div class="mt-4">
                <label class="inline-flex items-center">
                    <input type="checkbox" name="is_published" id="publishedInput" class="form-checkbox">
                    <span class="ml-2">Published</span>
                </label>
            </div>
            <div class="mt-4 flex justify-end space-x-4">
                <button type="button" onclick="resetForm()" class="px-4 py-2 border rounded hover:bg-gray-100">Cancel</button>
                <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">Save</button>
            </div>
        </form>
    </div>
</div>

<script>
    function editCourse(id, title, description, level, status, published, thumbnail) {
        document.getElementById("courseFormContainer").classList.remove("hidden");
        document.getElementById("formAction").value = "update";
        document.getElementById("courseId").value = id;
        document.getElementById("titleInput").value = title;
        document.getElementById("descriptionInput").value = description;
        document.getElementById("levelInput").value = level;
        document.getElementById("statusInput").value = status.toLowerCase();
        document.getElementById("publishedInput").checked = published;
        document.getElementById("thumbnailInput").value = thumbnail;

    }

    function resetForm() {
        document.getElementById("courseFormContainer").classList.add("hidden");
        document.getElementById("formAction").value = "add";
        document.getElementById("courseId").value = "";
        document.getElementById("titleInput").value = "";
        document.getElementById("levelInput").value = "Beginner";
        document.getElementById("statusInput").value = "active";
        document.getElementById("publishedInput").checked = false;
    }
    document.addEventListener('DOMContentLoaded', function () {
        const searchInput = document.getElementById('searchInput');
        const levelFilter = document.getElementById('levelFilter');
        const statusFilter = document.getElementById('statusFilter');
        const rows = document.querySelectorAll('.course-row');

        function filterCourses() {
            const search = searchInput.value.toLowerCase();
            const level = levelFilter.value;
            const status = statusFilter.value;

            rows.forEach(row => {
                const title = row.querySelector('.course-title')?.textContent.toLowerCase() || "";
                const desc = row.querySelector('.course-description')?.textContent.toLowerCase() || "";
                const rowLevel = row.querySelector('.course-level')?.textContent || "";
                const rowStatus = row.querySelector('.course-status')?.textContent.toLowerCase() || "";

                const matchSearch = title.includes(search) || desc.includes(search);
                const matchLevel = !level || rowLevel === level;
                const matchStatus = !status || rowStatus === status;

                row.style.display = (matchSearch && matchLevel && matchStatus) ? '' : 'none';
            });
        }

        searchInput.addEventListener('input', filterCourses);
        levelFilter.addEventListener('change', filterCourses);
        statusFilter.addEventListener('change', filterCourses);
    });
</script>
</body>
</html>
