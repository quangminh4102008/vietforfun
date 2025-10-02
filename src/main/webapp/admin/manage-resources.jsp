<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Resource Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">
<div class="container mx-auto px-4 py-8">
    <div class="flex justify-between items-center mb-6">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">Resource Management</h1>
            <p class="text-gray-500">Manage your learning resources here</p>
        </div>
        <button onclick="document.getElementById('resourceFormContainer').classList.remove('hidden'); resetForm();" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 shadow">
            <i class="fas fa-plus mr-2"></i> Add Resource
        </button>
    </div>

    <!-- Search + Filter Bar -->
    <div class="bg-white rounded-lg shadow p-4 mb-6 flex flex-col md:flex-row gap-4 items-center">
        <input type="text" id="searchInput" placeholder="Search by title..." class="flex-grow px-4 py-2 border border-gray-300 rounded-lg"/>
        <select id="typeFilter" class="px-4 py-2 border border-gray-300 rounded-lg">
            <option value="">All Types</option>
            <option value="PDF">PDF</option>
            <option value="Video">Video</option>
            <option value="Audio">Audio</option>
            <option value="Website">Website</option>
        </select>
        <select id="visibilityFilter" class="px-4 py-2 border border-gray-300 rounded-lg">
            <option value="">All Visibilities</option>
            <option value="Visible">Visible</option>
            <option value="Hidden">Hidden</option>
        </select>
    </div>

    <!-- Table -->
    <div class="bg-white shadow rounded-lg overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
            <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Title</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Visibility</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Uploaded At</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
            </tr>
            </thead>
            <tbody id="resourceTableBody" class="bg-white divide-y divide-gray-200">
            <c:forEach var="resource" items="${resources}">
                <%-- Thêm class 'opacity-50' nếu tài nguyên đã bị xóa mềm --%>
                <tr class="resource-row ${resource.deleted ? 'opacity-50 bg-red-50' : ''}">
                    <td class="px-6 py-4 whitespace-nowrap resource-title">
                            ${resource.title}
                            <%-- Thêm nhãn "Deleted" nếu cần --%>
                        <c:if test="${resource.deleted}">
                            <span class="ml-2 text-xs font-bold text-red-600">[DELETED]</span>
                        </c:if>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap resource-type">${resource.type}</td>
                    <td class="px-6 py-4 whitespace-nowrap resource-visibility">
            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${resource.visible ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                    ${resource.visible ? "Visible" : "Hidden"}
            </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">${fn:substring(resource.uploadedAt, 0, 19)}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                            <%-- Giữ nguyên form xóa, vì backend đã xử lý soft delete --%>
                        <form action="resources" method="post" class="inline" onsubmit="return confirm('Are you sure you want to delete this resource?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${resource.id}">
                            <button type="submit" class="text-red-600 hover:text-red-900" title="Delete"><i class="fas fa-trash"></i></button>
                        </form>

                            <%-- Nút edit nên được vô hiệu hóa nếu đã bị xóa --%>
                        <button
                                class="ml-4 text-indigo-600 hover:text-indigo-900 ${resource.deleted ? 'cursor-not-allowed text-gray-400' : ''}"
                                title="Edit" ${resource.deleted ? 'disabled' : ''}>
                            <i class="fas fa-edit"></i>
                        </button>

                            <%-- (Nâng cao) Bạn có thể thêm nút "Restore" ở đây --%>
                    </td>
                </tr>
            </c:forEach>    
            </tbody>
        </table>
    </div>

    <!-- Add/Edit Form -->
    <div id="resourceFormContainer" class="hidden mt-8 bg-white p-6 rounded-lg shadow-lg">
        <h2 id="formTitle" class="text-xl font-bold mb-4">Add New Resource</h2>
        <form action="resources" method="post">
            <input type="hidden" name="action" id="formAction" value="add">
            <input type="hidden" name="id" id="resourceId">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="col-span-2">
                    <label class="block mb-1 font-semibold text-gray-700">Title</label>
                    <input type="text" name="title" id="titleInput" required class="w-full border px-3 py-2 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" />
                </div>
                <div class="col-span-2">
                    <label class="block mb-1 font-semibold text-gray-700">URL (Link to PDF/Video/Audio/Website)</label>
                    <input type="url" name="url" id="urlInput" required placeholder="https://example.com/file.pdf" class="w-full border px-3 py-2 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" />
                </div>
                <div>
                    <label class="block mb-1 font-semibold text-gray-700">Type</label>
                    <select name="type" id="typeInput" required class="w-full border px-3 py-2 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="PDF">PDF</option>
                        <option value="Video">Video</option>
                        <option value="Audio">Audio</option>
                        <option value="Website">Website</option>
                    </select>
                </div>
                <div class="col-span-2">
                    <label class="block mb-1 font-semibold text-gray-700">Image URL (For Detail Page)</label>
                    <input type="url" name="imageUrl" id="imageUrlInput" placeholder="https://example.com/image.jpg" class="w-full border px-3 py-2 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" />
                </div>
                <div class="col-span-2">
                    <label class="block mb-1 font-semibold text-gray-700">Short Description (For Card View)</label>
                    <textarea name="description" id="descriptionInput" rows="3" required class="w-full border px-3 py-2 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                </div>
                <div class="col-span-2">
                    <label class="block mb-1 font-semibold text-gray-700">Full Content (HTML allowed for Detail Page)</label>
                    <textarea name="content" id="contentInput" rows="6" class="w-full border px-3 py-2 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                </div>
            </div>
            <div class="mt-6">
                <label class="inline-flex items-center">
                    <input type="checkbox" name="is_visible" id="visibleInput" class="form-checkbox h-5 w-5 text-blue-600 rounded">
                    <span class="ml-2 text-gray-700">Visible to users</span>
                </label>
            </div>
            <div class="mt-6 flex justify-end space-x-4">
                <button type="button" onclick="document.getElementById('resourceFormContainer').classList.add('hidden')" class="px-6 py-2 border rounded-lg hover:bg-gray-100">Cancel</button>
                <button type="submit" class="px-6 py-2 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700">Save Resource</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Note: Template literals (``) are used to handle multi-line strings from textareas.
    function editResource(id, title, description, type, url, imageUrl, content, isVisible) {
        resetForm(); // Clear the form first
        document.getElementById("resourceFormContainer").classList.remove("hidden");
        document.getElementById("formTitle").innerText = "Edit Resource";
        document.getElementById("formAction").value = "update";

        document.getElementById("resourceId").value = id;
        document.getElementById("titleInput").value = title;
        document.getElementById("descriptionInput").value = description;
        document.getElementById("typeInput").value = type;
        document.getElementById("urlInput").value = url;
        document.getElementById("imageUrlInput").value = imageUrl === 'null' ? '' : imageUrl;
        document.getElementById("contentInput").value = content;
        document.getElementById("visibleInput").checked = isVisible;

        // Scroll to the form for better user experience
        document.getElementById('resourceFormContainer').scrollIntoView({ behavior: 'smooth' });
    }

    function resetForm() {
        document.getElementById("resourceFormContainer").classList.add("hidden");
        document.getElementById("formTitle").innerText = "Add New Resource";
        document.getElementById("formAction").value = "add";
        document.getElementById("resourceId").value = "";

        // Reset all form fields
        document.querySelector('#resourceFormContainer form').reset();
        document.getElementById("visibleInput").checked = true; // Default to visible
    }

    // Client-side filtering logic
    document.addEventListener('DOMContentLoaded', function () {
        const searchInput = document.getElementById('searchInput');
        const typeFilter = document.getElementById('typeFilter');
        const visibilityFilter = document.getElementById('visibilityFilter');
        const rows = document.querySelectorAll('.resource-row');

        function filterResources() {
            const search = searchInput.value.toLowerCase();
            const type = typeFilter.value;
            const visibility = visibilityFilter.value;

            rows.forEach(row => {
                const title = row.querySelector('.resource-title')?.textContent.toLowerCase() || "";
                const rowType = row.querySelector('.resource-type')?.textContent || "";
                const rowVisibility = row.querySelector('.resource-visibility span')?.textContent.trim() || "";

                const matchSearch = title.includes(search);
                const matchType = !type || rowType === type;
                const matchVisibility = !visibility || rowVisibility === visibility;

                row.style.display = (matchSearch && matchType && matchVisibility) ? '' : 'none';
            });
        }

        searchInput.addEventListener('input', filterResources);
        typeFilter.addEventListener('change', filterResources);
        visibilityFilter.addEventListener('change', filterResources);

        // Set default form values on initial load
        resetForm();
    });
</script>
</body>
</html>