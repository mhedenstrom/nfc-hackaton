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
            //var root = AppContext.BaseDirectory;
            //var dbPath = Path.Combine(root, "disco.db");
            //var dataSource = $"Data Source={dbPath}";

            //Console.WriteLine("--DBPATH: " + dataSource);
            //options.UseSqlite(dataSource);

#if DEBUG
            var databasePath = $"{AppDomain.CurrentDomain.SetupInformation.ApplicationBase}discof.db";
            Console.WriteLine("--DBPATH: " + databasePath);
            options.UseSqlite($"Data Source={databasePath}");
#else
            var databasePath = $"{AppDomain.CurrentDomain.SetupInformation.ApplicationBase}discof.db";
            Console.WriteLine("--DBPATH: " + databasePath);
            options.UseSqlite($"Data Source={databasePath}");
            //var dbPath = @"c:\home\site\wwwroot\discof.db";
            //options.UseSqlite($"Data Source={databasePath}");
#endif
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
