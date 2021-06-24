using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Disco.Dal;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace DiscoBackend.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class DiscoController : ControllerBase
    {
        private readonly ILogger<DiscoController> _logger;

        public DiscoController(ILogger<DiscoController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        //public IEnumerable<Player> Get()
        public List<Summary> GetAll()
        {
            return MemCache.GetAll();
            /*
            var rng = new Random();
            return Enumerable.Range(1, 5).Select(index => new Player
                {
                    Name = "Player name",
                    Hole = rng.Next(20),
                    Score = rng.Next(9)
                })
                .ToArray();*/
        }

        [Route("setscore")]
        [HttpGet]
        public async Task<OkResult> SetScores(string player, int hole, int score)
        {
            MemCache.AddOrUpdateScore(player, new HoleScore{ Hole = hole, Score = score});
            /*
            using (var db = new PlayerContext())
            {
                var item = db.Players.FirstOrDefault(x => x.Name.Equals(player) && x.Hole == hole);
                if (item != null)
                {
                    item.Score = score;
                    db.Update(item);
                }
                else
                {
                    var row = new Player { Id = Guid.NewGuid(), Name = player, Hole = hole, Score = score };
                    await db.Players.AddAsync(row);
                }
                await db.SaveChangesAsync();
            }
            */
            return Ok();
        }

        [HttpGet]
        [Route("clear")]
        public async Task<OkResult> Clear()
        {
            MemCache.Clear();
            /*
            string databasePath = $"{AppDomain.CurrentDomain.SetupInformation.ApplicationBase}discof.db";
            _logger.LogError("DBPATH: " + databasePath);
            using (var db = new PlayerContext())
            {
                var all = from c in db.Players select c;
                db.Players.RemoveRange(all);
                await db.SaveChangesAsync();
            }
            */
            return Ok();
        }
    }
}
