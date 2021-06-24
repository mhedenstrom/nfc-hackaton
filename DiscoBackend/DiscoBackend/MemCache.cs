using System.Collections.Generic;
using System.Linq;

namespace DiscoBackend
{
    public class Summary
    {
        public string Player { get; set; }
        public int Hole { get; set; }
        public int Score { get; set; }
    }
    public class HoleScore
    {
        public int Hole { get; set; }
        public int Score { get; set; }
    }
    public static class MemCache
    {
        private static Dictionary<string, List<HoleScore>> Cache { get; set; } =
            new Dictionary<string, List<HoleScore>>();

        public static List<Summary> GetAll()
        {
            var res = new List<Summary>();
            foreach (var key in Cache.Keys)
            {
                foreach (var item in Cache[key])
                {
                    res.Add(new Summary
                    {
                        Player = key,
                        Hole = item.Hole,
                        Score = item.Score
                    });
                }
            }

            return res;
        }
        public static void AddOrUpdateScore(string player, HoleScore holeScore)
        {
            if (Cache.ContainsKey(player))
            {
                var item = Cache[player].FirstOrDefault(x => x.Hole == holeScore.Hole);
                if (item != null)
                {
                    item.Score = holeScore.Score;
                }
                else
                {
                    Cache[player].Add(holeScore);
                }
            }
            else
            {
                Cache[player] = new List<HoleScore>();
                Cache[player].Add(holeScore);
            }
        }
        public static void Clear()
        {
            Cache.Clear();
        }

        public static List<HoleScore> ScoresForPlayer(string player)
        {
            if (Cache.ContainsKey(player)) return Cache[player];
            return new List<HoleScore>();
        }
    }

}
