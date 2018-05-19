using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ado3.MODEL;
using OfficeOpenXml;
using System.IO;
using OfficeOpenXml.Style;
using System.Drawing;

namespace ado3
{
    class Program
    {
        public static MCS db = new MCS();
        static void Main(string[] args)
        {
            var list = db.Area.Where(w => w.WorkingPeople > 2);

            /*foreach (Document  doc  in db.Document.ToList())
            {
                var timer = db.Timer.Where(w => w.DocumentId == doc.DocumentId).Take(10).ToList();
                foreach (Timer  time in timer)
                {
                    Console.WriteLine($"Area: {time.Area.Name}, {time.DateStart}-{time.DateFinish}");
                }
            }*/
            //ReportArea(db.Area);
            //OrderExecution(list);
            //RepeatIP();
            //TimerFromTo();
            //TimerDataI();
            JoinAreaTimer();
            Console.ReadKey();   
        }
        private static void ReportArea(IQueryable<Area> areas)
        {
            ExcelPackage package = new ExcelPackage();

            #region 
            var worksheet=package.Workbook.Worksheets.Add("Report1");
            worksheet.Column(1).Width = 50;
            worksheet.Cells[1,1].Value = "FullName";
            int row = 2;
            foreach (var item in areas.ToList())
            {
                worksheet.Cells[row++, 1].Value = item.Name;
            }
            using (var rng = worksheet.Cells[1, 1, row-1, 1])
            {
                rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

                rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
            }

            var color = ColorTranslator.FromHtml("#FF8000");
            worksheet.Cells[1, 1].Style.Fill.PatternType = ExcelFillStyle.Solid;
            worksheet.Cells[1, 1].Style.Fill.BackgroundColor.SetColor(color);

            #endregion

            var worksheet2 = package.Workbook.Worksheets.Add("Report2");

            row = 1;
            foreach (var item in areas.Where(w => w.AssemblyArea != null)
                                      .Where(w => (bool)w.AssemblyArea)
                                      .Select(s=>new { s.FullName, s.AssemblyArea })
                                      .OrderBy(o=>o.FullName)) 
            {
                worksheet2.Cells[row, 1].Value = item.FullName;
                worksheet2.Cells[row++, 2].Value = item.AssemblyArea.ToString();
            }

            Stream stream = File.Create("Area.xlsx");
            package.SaveAs(stream);
            stream.Close();
        }
        private static void OrderExecution(IQueryable<Area> areas)
        {
            var list = db.Area.ToList();
            var obj  = list.TakeWhile(t => t.OrderExecution == 0);
            foreach (var item in obj)
            {
                Console.WriteLine(item);
            }
        }
        private static void RepeatIP()
        {
            var f = db.Area.GroupBy(g => new { g.IP }).Select(s => new { s.Key.IP, ipCount = s.Count() });

            foreach (var item in f.Where(w=>w.ipCount==1))
            {
                Console.WriteLine($"{item.IP} - {item.ipCount}");
            } 
        }
        private static void TimerFromTo()
        {
            List<int> list = new List<int>() { 22, 23, 24, 25, 26, 27, 28 };
            var t = db.Timer.ToList();
            var res = t.Where(p => list.Contains((int)p.AreaId)).ToList();

            foreach (var item in res)
            {
                Console.WriteLine($"{item.AreaId} - {item.Area.FullName} - {item.DurationInSeconds}");
            }
        }
        private static void TimerDataI()
        {
            List<int> list = new List<int>() { 22 };
            var t = db.Timer.ToList();
            var data= t.Where(p => list.Contains((int)p.AreaId))
                       .Where(w=>w.DateStart>=new DateTime(2017,09,8)&&w.DateStart<=new DateTime(2017,09,18))
                       .Where(df=>df.DateFinish!=null).ToList();
            foreach (var item in data)
            {
                Console.WriteLine($"{item.AreaId} {item.Area.FullName}");
            }
        }
        private static void JoinAreaTimer()
        {
            var timer = db.Timer.ToList();
            var area = db.Area.ToList();

            var result = timer.Join(area, a => a.AreaId, t => t.AreaId, (a, t) =>new { Name = t.FullName, Start = a.DateStart.Value.Date }).Distinct();

            foreach (var item in result)
            {
                Console.WriteLine($"{item.Name} - {item.Start:dd:MM:yyyy}");
            }
        }
    }
}
