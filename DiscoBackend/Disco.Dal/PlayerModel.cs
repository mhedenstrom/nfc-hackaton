using System;
using System.ComponentModel.DataAnnotations;
using System.IO;
using Microsoft.EntityFrameworkCore;

namespace Disco.Dal
{
    // Add-Migration InitialCreate
    // Update-Database

    public class PlayerContext : DbContext
    {
        public DbSet<Player> Players { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder options)
        {
            options.UseSqlite($"Data Source=discof.db");
        }
    }
    public class Player
    {
        [Key]
        public Guid Id { get; set; }
        public string Name { get; set; }
        public int Score { get; set; }
        public int Hole { get; set; }
    }
}
