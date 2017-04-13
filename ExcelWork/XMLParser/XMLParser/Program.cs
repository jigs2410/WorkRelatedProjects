using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace XMLParser
{
    class Program
    {
        static void Main(string[] args)
        {


            XElement xelement = XElement.Load("Employees.xml");
            IEnumerable<XElement> employees = xelement.Elements();
            //Console.WriteLine("List of all Employee Names :");
            Console.WriteLine("List of all Employee Names along with their ID :");
            foreach (var employee in employees)
            {
                //Console.WriteLine(employee.Element("Name").Value);
                Console.WriteLine("{0} has Employee ID {1}",
                                    employee.Element("Name").Value,
                                    employee.Element("EmpId").Value

                    );
            }

            var name = from nm in xelement.Elements("Employee")
                       where (string)nm.Element("Sex") == "Female"
                       select nm;
            Console.WriteLine("Details of Female Employees");
            foreach (XElement xEle in name)
                Console.WriteLine(xEle);

            var homePhone = from phoneno in xelement.Elements("Employee")
                            where (string)phoneno.Element("Phone").Attribute("Type") == "Home"
                            select phoneno;
            Console.WriteLine("List HomePhone Nos.");
            foreach (XElement xEle in homePhone)
                Console.WriteLine(xEle.Element("Phone").Value);

            var addresses = from address in xelement.Elements("Employee")
                            where (string)address.Element("Address").Element("City") == "Alta"
                            select address;
            Console.WriteLine("Details of Employess Living in Alta");
            foreach (XElement xEle in addresses)
                Console.WriteLine(xEle);

            Console.WriteLine("List of all Zip Codes");
            foreach (XElement xEle in xelement.Descendants("Zip"))
            {
                Console.WriteLine((string)xEle);
            }

            IEnumerable<string> codes = from code in xelement.Elements("Employee")
                                        let zip = (string)code.Element("Address").Element("Zip")
                                        orderby zip
                                        select zip;
            Console.WriteLine("List and Sort all Zip Codes");


            foreach (string zp in codes)
                Console.WriteLine(zp);

        }
    }
}
