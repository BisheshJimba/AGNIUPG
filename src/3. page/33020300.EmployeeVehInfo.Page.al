page 33020300 "Employee Veh. Info."
{
    PageType = List;
    SourceTable = Table33019983;
    SourceTableView = ORDER(Ascending)
                      WHERE(Entry Type=CONST(Employee));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Type; Type)
                {
                }
                field("Vehicle No./Reg. No."; "Vehicle No./Reg. No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

