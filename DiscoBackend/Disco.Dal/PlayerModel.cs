using System;
using System.ComponentModel.DataAnnotations;
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
            var dataSource = "Data Source=disco.db";
            options.UseSqlite(dataSource);
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
