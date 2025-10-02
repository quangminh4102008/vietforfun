<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Questions</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-100">
<div class="container mx-auto px-4 py-6">
    <h1 class="text-2xl font-bold text-gray-800 mb-4">Manage Questions for Course #${courseId}</h1>
    <button onclick="toggleAddForm()" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
        <i class="fas fa-plus mr-1"></i> Add Question
    </button>

    <!-- 🔍 Search + Filter -->
    <div class="bg-white rounded-lg shadow p-4 mb-6 flex flex-col md:flex-row gap-4">
        <input type="text" id="searchInput" placeholder="Search by question text..."
               class="flex-1 px-4 py-2 border border-gray-300 rounded"/>
        <select id="typeFilter" class="px-4 py-2 border border-gray-300 rounded">
            <option value="">All Types</option>
            <option value="multiple_choice">Multiple Choice</option>
            <option value="fill_blank">Fill in the Blank</option>
            <option value="listening">Listening</option>
        </select>
    </div>

    <!-- 📋 Table -->
    <div class="bg-white shadow rounded overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50 text-sm text-gray-600">
            <tr>
                <th class="px-4 py-2 text-left">Text</th>
                <th class="px-4 py-2 text-left">Type</th>
                <th class="px-4 py-2 text-left">Correct Answer</th>
                <th class="px-4 py-2 text-left">Audio</th>
                <th class="px-4 py-2 text-left">Image</th>
                <th class="px-4 py-2 text-left">Status</th>
                <th class="px-4 py-2 text-left">Actions</th>
            </tr>
            </thead>
            <tbody id="questionTableBody" class="text-sm text-gray-800">
            <c:forEach var="q" items="${questionList}">
                <tr class="question-row hover:bg-yellow-50">
                    <td class="px-4 py-2 question-text">${q.questionText}</td>
                    <td class="px-4 py-2 question-type">${q.type}</td>
                    <td class="px-4 py-2">${q.correctAnswer}</td>
                    <td class="px-4 py-2">
                        <c:if test="${not empty q.audioUrl}">
                            <audio controls src="${q.audioUrl}" class="w-40"></audio>
                        </c:if>
                    </td>
                    <td class="px-4 py-2">
                        <c:if test="${not empty q.imageUrl}">
                            <img src="${q.imageUrl}" class="w-16 h-16 object-cover rounded" />
                        </c:if>
                    </td>

                    <td class="px-4 py-2 question-status">${q.status}</td>
                    <td class="px-4 py-2">
                        <form action="questions" method="post" class="inline">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${q.id}">
                            <input type="hidden" name="courseId" value="${courseId}">
                            <button type="submit" class="text-red-600 hover:text-red-800">
                                <i class="fas fa-trash"></i>
                            </button>
                        </form>
                        <a href="questions?courseId=${courseId}&editId=${q.id}" class="ml-3 text-blue-600 hover:text-blue-800">
                            <i class="fas fa-edit"></i>
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<c:if test="${not empty editQuestion}">
    <div class="mt-8 bg-white p-6 shadow rounded">
        <h2 class="text-xl font-bold mb-4">Edit Question</h2>
        <form action="questions" method="post" class="space-y-4">
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="id" value="${editQuestion.id}" />
            <input type="hidden" name="courseId" value="${courseId}" />

            <div>
                <label class="block font-semibold mb-1">Question Text</label>
                <textarea name="questionText" required class="w-full border px-3 py-2 rounded">${editQuestion.questionText}</textarea>
            </div>

            <div>
                <label class="block font-semibold mb-1">Type</label>
                <select name="type" required class="w-full border px-3 py-2 rounded">
                    <option value="multiple_choice" ${editQuestion.type == 'multiple_choice' ? 'selected' : ''}>Multiple Choice</option>
                    <option value="fill_blank" ${editQuestion.type == 'fill_blank' ? 'selected' : ''}>Fill in the Blank</option>
                    <option value="listening" ${editQuestion.type == 'listening' ? 'selected' : ''}>Listening</option>
                </select>
            </div>
            <div>
                <label class="block font-semibold mb-1">Image URL</label>
                <input type="text" name="imageUrl" value="${editQuestion.imageUrl}" class="w-full border px-3 py-2 rounded" />
            </div>

            <div>
                <label class="block font-semibold mb-1">Audio URL</label>
                <input type="text" name="audioUrl" value="${editQuestion.audioUrl}" class="w-full border px-3 py-2 rounded" />
            </div>

            <div>
                <label class="block font-semibold mb-1">Correct Answer</label>
                <input type="text" name="correctAnswer" value="${editQuestion.correctAnswer}" class="w-full border px-3 py-2 rounded" />
            </div>

            <div class="grid grid-cols-2 gap-4">
                <div><label>Option A</label><input type="text" name="optionA" value="${editQuestion.optionA}" class="w-full border px-3 py-2 rounded" /></div>
                <div><label>Option B</label><input type="text" name="optionB" value="${editQuestion.optionB}" class="w-full border px-3 py-2 rounded" /></div>
                <div><label>Option C</label><input type="text" name="optionC" value="${editQuestion.optionC}" class="w-full border px-3 py-2 rounded" /></div>
                <div><label>Option D</label><input type="text" name="optionD" value="${editQuestion.optionD}" class="w-full border px-3 py-2 rounded" /></div>
            </div>

            <div>
                <label class="block font-semibold mb-1">Explanation</label>
                <textarea name="explanation" class="w-full border px-3 py-2 rounded">${editQuestion.explanation}</textarea>
            </div>

            <div class="flex justify-end">
                <button type="submit" class="bg-yellow-600 text-white px-4 py-2 rounded hover:bg-yellow-700">
                    Update Question
                </button>
            </div>
        </form>
    </div>
</c:if>

<div id="addForm" class="mt-6 bg-white p-6 rounded shadow" style="display: none;">
    <h2 class="text-xl font-bold mb-4">Add New Question</h2>
    <form action="questions" method="post" class="space-y-4">
        <input type="hidden" name="action" value="add" />
        <input type="hidden" name="courseId" value="${courseId}" />

        <div>
            <label class="block font-semibold mb-1">Question Text</label>
            <textarea name="questionText" required class="w-full border px-3 py-2 rounded"></textarea>
        </div>

        <div>
            <label class="block font-semibold mb-1">Type</label>
            <select name="type" required class="w-full border px-3 py-2 rounded">
                <option value="multiple_choice">Multiple Choice</option>
                <option value="fill_blank">Fill in the Blank</option>
                <option value="listening">Listening</option>
            </select>
        </div>
        <div>
            <label class="block font-semibold mb-1">Image URL</label>
            <input type="text" name="imageUrl" value="${editQuestion.imageUrl}" class="w-full border px-3 py-2 rounded" />
        </div>

        <div>
            <label class="block font-semibold mb-1">Audio URL (for Listening)</label>
            <input type="text" name="audioUrl" class="w-full border px-3 py-2 rounded"/>
        </div>

        <div>
            <label class="block font-semibold mb-1">Correct Answer</label>
            <input type="text" name="correctAnswer" class="w-full border px-3 py-2 rounded"/>
        </div>

        <div class="grid grid-cols-2 gap-4">
            <div>
                <label class="block">Option A</label>
                <input type="text" name="optionA" class="w-full border px-3 py-2 rounded"/>
            </div>
            <div>
                <label class="block">Option B</label>
                <input type="text" name="optionB" class="w-full border px-3 py-2 rounded"/>
            </div>
            <div>
                <label class="block">Option C</label>
                <input type="text" name="optionC" class="w-full border px-3 py-2 rounded"/>
            </div>
            <div>
                <label class="block">Option D</label>
                <input type="text" name="optionD" class="w-full border px-3 py-2 rounded"/>
            </div>
        </div>

        <div>
            <label class="block font-semibold mb-1">Explanation</label>
            <textarea name="explanation" class="w-full border px-3 py-2 rounded"></textarea>
        </div>

        <div class="flex justify-end">
            <button type="submit" class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">
                Add Question
            </button>
        </div>
    </form>
</div>

<!-- ✅ JavaScript: search & filter -->
<script>
    function toggleAddForm() {
        const form = document.getElementById('addForm');
        form.style.display = form.style.display === 'none' ? 'block' : 'none';
    }
    document.addEventListener('DOMContentLoaded', function () {
        const searchInput = document.getElementById('searchInput');
        const typeFilter = document.getElementById('typeFilter');
        const rows = document.querySelectorAll('.question-row');

        function filterQuestions() {
            const search = searchInput.value.toLowerCase();
            const type = typeFilter.value;

            rows.forEach(row => {
                const text = row.querySelector('.question-text')?.textContent.toLowerCase() || "";
                const rowType = row.querySelector('.question-type')?.textContent || "";

                const matchSearch = text.includes(search);
                const matchType = !type || rowType === type;

                row.style.display = (matchSearch && matchType) ? '' : 'none';
            });
        }

        searchInput.addEventListener('input', filterQuestions);
        typeFilter.addEventListener('change', filterQuestions);
    });
</script>
</body>
</html>
