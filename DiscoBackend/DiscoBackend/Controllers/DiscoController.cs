using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
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
        public IEnumerable<Player> Get()
        {
            var rng = new Random();
            return Enumerable.Range(1, 5).Select(index => new Player
                {
                    Name = "Player name",
                    Hole = rng.Next(20),
                    Score = rng.Next(9)
                })
                .ToArray();
        }
    }
}
