using Microsoft.EntityFrameworkCore;
using TrabajadoresApp.Models;

namespace TrabajadoresApp.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<Trabajador> Trabajadores { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Trabajador>(entity =>
            {
                entity.ToTable("Trabajadores");
                entity.HasKey(e => e.Id);

                // Configuraciones que coincidan con tu BD
                entity.Property(e => e.Nombres)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.Apellidos)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.TipoDocumento)
                    .IsRequired()
                    .HasMaxLength(20);

                entity.Property(e => e.NumeroDocumento)
                    .IsRequired()
                    .HasMaxLength(20);

                entity.Property(e => e.Sexo)
                    .IsRequired()
                    .HasMaxLength(10);

                entity.Property(e => e.Foto)
                    .HasMaxLength(255);

                entity.Property(e => e.Direccion)
                    .HasMaxLength(200);

                // Estas propiedades tienen valores por defecto en la BD
                // No es necesario configurarlas en EF
            });
        }
    }
}