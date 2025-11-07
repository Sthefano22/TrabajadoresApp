using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TrabajadoresApp.Data;
using TrabajadoresApp.Models;
using System.Linq;
using System.Threading.Tasks;

namespace TrabajadoresApp.Controllers
{
    public class TrabajadoresController : Controller
    {
        private readonly ApplicationDbContext _context;

        public TrabajadoresController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Trabajadores
        public async Task<IActionResult> Index()
        {
            var trabajadores = await _context.Trabajadores
                .Where(t => t.Estado)
                .OrderByDescending(t => t.FechaCreacion)
                .ToListAsync();
            return View(trabajadores);
        }

        // GET: Trabajadores/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Trabajadores/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Nombres,Apellidos,TipoDocumento,NumeroDocumento,Sexo,FechaNacimiento,Foto,Direccion")] Trabajador trabajador)
        {
            if (ModelState.IsValid)
            {
                // Verificar si ya existe el número de documento
                var existe = await _context.Trabajadores
                    .AnyAsync(t => t.NumeroDocumento == trabajador.NumeroDocumento && t.Estado);

                if (existe)
                {
                    ModelState.AddModelError("NumeroDocumento", "Ya existe un trabajador con este número de documento");
                    return View(trabajador);
                }

                _context.Add(trabajador);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = "Trabajador creado exitosamente.";
                return RedirectToAction(nameof(Index));
            }
            return View(trabajador);
        }

        // GET: Trabajadores/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var trabajador = await _context.Trabajadores.FindAsync(id);
            if (trabajador == null || !trabajador.Estado)
            {
                return NotFound();
            }
            return View(trabajador);
        }

        // POST: Trabajadores/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,Nombres,Apellidos,TipoDocumento,NumeroDocumento,Sexo,FechaNacimiento,Foto,Direccion,Estado")] Trabajador trabajador)
        {
            if (id != trabajador.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    // Verificar si el número de documento ya existe en otro registro
                    var existe = await _context.Trabajadores
                        .AnyAsync(t => t.Id != trabajador.Id &&
                                      t.NumeroDocumento == trabajador.NumeroDocumento &&
                                      t.Estado);

                    if (existe)
                    {
                        ModelState.AddModelError("NumeroDocumento", "Ya existe un trabajador con este número de documento");
                        return View(trabajador);
                    }

                    trabajador.FechaActualizacion = DateTime.Now;
                    _context.Update(trabajador);
                    await _context.SaveChangesAsync();
                    TempData["SuccessMessage"] = "Trabajador actualizado exitosamente.";
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!TrabajadorExists(trabajador.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(trabajador);
        }

        // GET: Trabajadores/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var trabajador = await _context.Trabajadores
                .FirstOrDefaultAsync(m => m.Id == id && m.Estado);
            if (trabajador == null)
            {
                return NotFound();
            }

            return View(trabajador);
        }

        // POST: Trabajadores/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var trabajador = await _context.Trabajadores.FindAsync(id);
            if (trabajador != null)
            {
                trabajador.Estado = false;
                trabajador.FechaActualizacion = DateTime.Now;
                _context.Update(trabajador);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = "Trabajador eliminado exitosamente.";
            }
            return RedirectToAction(nameof(Index));
        }

        private bool TrabajadorExists(int id)
        {
            return _context.Trabajadores.Any(e => e.Id == id && e.Estado);
        }
    }
}