using Swashbuckle.AspNetCore.Filters;
using Microsoft.AspNetCore.Mvc;
using TinyTasksApi.Models;

namespace TinyTasksApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TasksController : ControllerBase
    {
        private static List<TaskItem> _tasks = new();
        private static int _nextId = 1;

        /// <summary>
        /// Retrieves all tasks.
        /// </summary>
        /// <returns>A list of all task items.</returns>
        [HttpGet]
        public ActionResult<IEnumerable<TaskItem>> GetAll()
        {
            return Ok(_tasks);
        }

        /// <summary>
        /// Retrieves a specific task by ID.
        /// </summary>
        /// <param name="id">The ID of the task to retrieve.</param>
        /// <returns>The requested task item if found; otherwise, 404.</returns>
        [HttpGet("{id}")]
        public ActionResult<TaskItem> Get(int id)
        {
            var task = _tasks.FirstOrDefault(t => t.Id == id);
            if (task == null)
                return NotFound();
            return Ok(task);
        }

        /// <summary>
        /// Creates a new task.
        /// </summary>
        /// <param name="newTask">The task to create (e.g., { "title": "Buy groceries", "isCompleted": false }).</param>
        /// <returns>The created task with an assigned ID.</returns>
        [SwaggerRequestExample(typeof(TaskItem), typeof(CreateTaskItemExample))]
        [HttpPost]
        public ActionResult<TaskItem> Create(TaskItem newTask)
        {
            newTask.Id = _nextId++;
            _tasks.Add(newTask);
            return CreatedAtAction(nameof(Get), new { id = newTask.Id }, newTask);
        }

        /// <summary>
        /// Deletes a task by ID.
        /// </summary>
        /// <param name="id">The ID of the task to delete (e.g., 1).</param>
        /// <returns>200 OK if successful; 404 if not found.</returns>
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var task = _tasks.FirstOrDefault(t => t.Id == id);
            if (task == null)
                return NotFound();
            _tasks.Remove(task);
            return Ok();
        }
        
        /// <summary>
        /// Fully updates a task by ID.
        /// </summary>
        /// <param name="id">The ID of the task to update (e.g., 1).</param>
        /// <param name="updatedTask">Updated task fields (e.g., { "title": "Buy groceries", "isCompleted": true }).</param>
        /// <returns>200 OK if successful; 404 if not found.</returns>
        [HttpPut("{id}")]
        public IActionResult Update(int id, TaskItem updatedTask)
        {
            var task = _tasks.FirstOrDefault(t => t.Id == id);
            if (task == null)
                return NotFound();

            task.Title = updatedTask.Title;
            task.IsCompleted = updatedTask.IsCompleted;

            return Ok(task);
        }

        /// <summary>
        /// Partially updates a task by ID.
        /// </summary>
        /// <param name="id">The ID of the task to update (e.g., 1).</param>
        /// <param name="updates">A dictionary of fields to update (e.g., { "isCompleted": true }).</param>
        /// <returns>200 OK if successful; 404 if not found.</returns>
        [HttpPatch("{id}")]
        public IActionResult PartialUpdate(int id, [FromBody] Dictionary<string, object> updates)
        {
            var task = _tasks.FirstOrDefault(t => t.Id == id);
            if (task == null)
                return NotFound();

            if (updates.ContainsKey("Title"))
                task.Title = updates["Title"]?.ToString() ?? task.Title;

            if (updates.ContainsKey("IsCompleted") && bool.TryParse(updates["IsCompleted"]?.ToString(), out var isCompleted))
                task.IsCompleted = isCompleted;

            return Ok(task);
        }
    }
    public class CreateTaskItemExample : IExamplesProvider<TaskItem>
    {
        public TaskItem GetExamples()
        {
            return new TaskItem
            {
                Title = "Test the tasks api",
                IsCompleted = false
            };
        }
    }
}