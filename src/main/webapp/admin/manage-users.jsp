<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Management – VietJoy</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
</head>
<body class="bg-gray-100">
<div class="container mx-auto px-4 py-8">

    <div class="flex justify-between items-center mb-6">
        <div>
            <h1 class="text-2xl font-bold text-gray-800">User Management</h1>
            <p class="text-gray-500">Manage your users here</p>
        </div>
        <button onclick="document.getElementById('userFormContainer').classList.remove('hidden')"
                class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
            <i class="fas fa-plus mr-2"></i> Add User
        </button>
    </div>

    <!-- Filters + Search -->
    <div class="bg-white rounded-lg shadow p-4 mb-6 flex flex-col md:flex-row gap-4">
        <input type="text" id="searchInput" placeholder="Search username or email..."
               class="flex-1 px-4 py-2 border border-gray-300 rounded"/>

        <select id="roleFilter" class="px-4 py-2 border border-gray-300 rounded">
            <option value="">All Roles</option>
            <option value="user">User</option>
            <option value="admin">Admin</option>
        </select>

        <select id="activeFilter" class="px-4 py-2 border border-gray-300 rounded">
            <option value="">All Statuses</option>
            <option value="true">Active</option>
            <option value="false">Inactive</option>
        </select>
    </div>

    <!-- Table -->
    <div class="bg-white shadow rounded overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
            <tr>
                <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Username</th>
                <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Email</th>
                <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Role</th>
                <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Status</th>
                <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Level</th>
                <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Actions</th>
            </tr>
            </thead>
            <tbody id="userTableBody" class="bg-white divide-y divide-gray-200">
            <c:forEach var="u" items="${userList}">
                <tr class="user-row"
                    data-username="${fn:toLowerCase(u.username)}"
                    data-email="${fn:toLowerCase(u.email)}"
                    data-role="${fn:toLowerCase(u.role)}"
                    data-active="${u.active}"
                    data-level="${fn:toLowerCase(u.level)}">
                    <td class="px-6 py-4">${u.username}</td>
                    <td class="px-6 py-4">${u.email}</td>
                    <td class="px-6 py-4">${u.role}</td>
                    <td class="px-6 py-4">${u.active ? 'Active' : 'Inactive'}</td>
                    <td class="px-6 py-4">${u.level}</td>
                    <td class="px-6 py-4 space-x-2">
                        <button onclick="editUser(
                                '${u.id}',
                                '${fn:escapeXml(u.username)}',
                                '${fn:escapeXml(u.email)}',
                                '${u.role}',
                                '${u.active}',
                                '${u.level}'
                                )"
                                class="text-blue-600 hover:text-blue-800">
                            <i class="fas fa-edit"></i>
                        </button>
                        <form action="users" method="post" class="inline">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${u.id}">
                            <button type="submit" class="text-red-600 hover:text-red-800">
                                <i class="fas fa-trash"></i>
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Add/Edit Form -->
    <div id="userFormContainer" class="hidden mt-8 bg-white p-6 rounded shadow">
        <form action="users" method="post">
            <input type="hidden" name="action" value="add" id="formAction">
            <input type="hidden" name="id" id="userId">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block mb-1 font-semibold">Username</label>
                    <input type="text" name="username" id="usernameInput" required class="w-full border px-3 py-2 rounded" />
                </div>
                <div>
                    <label class="block mb-1 font-semibold">Email</label>
                    <input type="email" name="email" id="emailInput" required class="w-full border px-3 py-2 rounded" />
                </div>
                <div>
                    <label class="block mb-1 font-semibold">Password</label>
                    <input type="password" name="password" id="passwordInput"
                           class="w-full border px-3 py-2 rounded" placeholder="Leave blank to keep"/>
                </div>
                <div>
                    <label class="block mb-1 font-semibold">Role</label>
                    <select name="role" id="roleInput" required class="w-full border px-3 py-2 rounded">
                        <option value="user">User</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
                <div>
                    <label class="block mb-1 font-semibold">Status</label>
                    <select name="active" id="activeInput" required class="w-full border px-3 py-2 rounded">
                        <option value="true">Active</option>
                        <option value="false">Inactive</option>
                    </select>
                </div>
                <div>
                    <label class="block mb-1 font-semibold">Level</label>
                    <select name="level" id="levelInput" required class="w-full border px-3 py-2 rounded">
                        <option value="Beginner">Beginner</option>
                        <option value="Intermediate">Intermediate</option>
                        <option value="Advanced">Advanced</option>
                    </select>
                </div>
            </div>

            <div class="mt-4 flex justify-end space-x-4">
                <button type="button" onclick="resetForm()"
                        class="px-4 py-2 border rounded hover:bg-gray-100">Cancel</button>
                <button type="submit"
                        class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">Save</button>
            </div>
        </form>
    </div>
</div>

<script>
    function editUser(id, username, email, role, active, level) {
        document.getElementById("userFormContainer").classList.remove("hidden");
        document.getElementById("formAction").value = "update";
        document.getElementById("userId").value = id;
        document.getElementById("usernameInput").value = username;
        document.getElementById("emailInput").value = email;
        document.getElementById("passwordInput").value = "";
        document.getElementById("roleInput").value = role;
        document.getElementById("activeInput").value = active;
        document.getElementById("levelInput").value = level;
    }
    function resetForm() {
        document.getElementById("userFormContainer").classList.add("hidden");
        document.getElementById("formAction").value = "add";
        document.getElementById("userId").value = "";
        document.getElementById("usernameInput").value = "";
        document.getElementById("emailInput").value = "";
        document.getElementById("passwordInput").value = "";
        document.getElementById("roleInput").value = "user";
        document.getElementById("activeInput").value = "true";
        document.getElementById("levelInput").value = "Beginner";
    }

    document.addEventListener('DOMContentLoaded', () => {
        const searchInput = document.getElementById('searchInput');
        const roleFilter  = document.getElementById('roleFilter');
        const activeFilter= document.getElementById('activeFilter');
        const rows        = document.querySelectorAll('.user-row');

        function filterUsers() {
            const term = searchInput.value.toLowerCase();
            const role = roleFilter.value;
            const act  = activeFilter.value;

            rows.forEach(r => {
                const uname = r.dataset.username;
                const mail  = r.dataset.email;
                const rRole = r.dataset.role;
                const rAct  = r.dataset.active;
                const matchSearch = uname.includes(term) || mail.includes(term);
                const matchRole   = !role || rRole === role;
                const matchActive = !act  || rAct === act;
                r.style.display = (matchSearch && matchRole && matchActive) ? '' : 'none';
            });
        }
        searchInput.addEventListener('input', filterUsers);
        roleFilter.addEventListener('change', filterUsers);
        activeFilter.addEventListener('change', filterUsers);
    });
</script>
</body>
</html>
