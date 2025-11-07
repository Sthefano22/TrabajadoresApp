using Microsoft.AspNetCore.Mvc;
using TrabajadoresApp.Data;

namespace TrabajadoresApp.Controllers
{
    public class HomeController : Controller
    {
        private readonly ApplicationDbContext _context;

        public HomeController(ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            // Probar conexión a la base de datos
            try
            {
                var count = _context.Trabajadores.Count();
                ViewData["Message"] = $"Conexión exitosa. Hay {count} trabajadores en la BD.";
            }
            catch (Exception ex)
            {
                ViewData["Message"] = $"Error de conexión: {ex.Message}";
            }

            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }
    }
}