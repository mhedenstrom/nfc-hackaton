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
        private const bool UseMemcache = true;

        public DiscoController(ILogger<DiscoController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public List<Summary> GetAll()
        {
            return MemCache.GetAll();
        }

        [Route("setscore")]
        [HttpGet]
        public async Task<OkResult> SetScores(string player, int hole, int score)
        {
            MemCache.AddOrUpdateScore(player, new HoleScore{ Hole = hole, Score = score});
            return Ok();
        }

        [HttpGet]
        [Route("clear")]
        public async Task<OkResult> Clear()
        {
            MemCache.Clear();
            return Ok();
        }

        [HttpGet]
        [Route("cleardb")]
        public async Task<OkResult> ClearDb()
        {
            using (var db = new PlayerContext())
            {
                var all = from c in db.Players select c;
                db.Players.RemoveRange(all);
                await db.SaveChangesAsync();
            }
            return Ok();
        }

        [HttpGet]
        [Route("getalldb")]
        public IEnumerable<Player> GetAllLPlayers()
        {
            using (var db = new PlayerContext())
            {
                return db.Players.ToList();
            }

        }
        [Route("setscoredb")]
        [HttpGet]
        public async Task<OkResult> SetScoreDb(string player, int hole, int score)
        {
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
            return Ok();
        }

        [HttpGet]
        [Route("getscores")]
        public int GetScores(string name)
        {
            using (var db = new PlayerContext())
            {
                return db.Players.Where(x => x.Name.Equals(name)).Sum(x => x.Score);
            }
        }

    }
}
