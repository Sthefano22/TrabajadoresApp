using System;
using System.ComponentModel.DataAnnotations;

namespace TrabajadoresApp.Models
{
    public class Trabajador
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Los nombres son obligatorios")]
        [StringLength(100)]
        public string Nombres { get; set; }

        [Required(ErrorMessage = "Los apellidos son obligatorios")]
        [StringLength(100)]
        public string Apellidos { get; set; }

        [Required(ErrorMessage = "El tipo de documento son obligatorios")]
        [StringLength(20)]
        public string TipoDocumento { get; set; }

        [Required(ErrorMessage = "El número de documento es obligatorio")]
        [StringLength(20)]
        public string NumeroDocumento { get; set; }

        [Required(ErrorMessage = "El sexo es obligatorio")]
        [StringLength(10)]
        public string Sexo { get; set; }

        [Required(ErrorMessage = "La fecha de nacimiento es obligatoria")]
        [DataType(DataType.Date)]
        public DateTime FechaNacimiento { get; set; }

        // CAMBIAR A NULLABLE
        [StringLength(255)]
        public string? Foto { get; set; }  // <- Agregar ? para nullable

        // CAMBIAR A NULLABLE  
        [StringLength(200)]
        public string? Direccion { get; set; }  // <- Agregar ? para nullable

        public DateTime FechaCreacion { get; set; } = DateTime.Now;

        public DateTime? FechaActualizacion { get; set; }

        public bool Estado { get; set; } = true;

        // Propiedades de solo lectura
        public string NombreCompleto => $"{Nombres} {Apellidos}";

        public int Edad
        {
            get
            {
                var today = DateTime.Today;
                var age = today.Year - FechaNacimiento.Year;
                if (FechaNacimiento.Date > today.AddYears(-age)) age--;
                return age;
            }
        }
    }
}