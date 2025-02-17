page 33019920 "Posted Job List"
{
    CardPageID = "Battery Job Header";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = Table33019894;
    SourceTableView = SORTING(Job Card No.)
                      WHERE(Exide Claim=CONST(No),
                            Action=CONST(" "));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Card No.";"Job Card No.")
                {
                }
                field("Customer Name";"Customer Name")
                {
                }
                field(CustomerPhone;CustomerPhone)
                {
                    Caption = 'Customer Phone No.';
                }
                field("Battery Part No.";"Battery Part No.")
                {
                }
                field("Battery Serial No.";"Battery Serial No.")
                {
                }
                field(MFG;MFG)
                {
                }
                field("Serv Batt Type";"Serv Batt Type")
                {
                }
                field("Job Start Date";"Job Start Date")
                {
                }
                field(JobAge;JobAge)
                {
                    Caption = 'Job Age';
                }
            }
        }
        area(factboxes)
        {
            part(;33019921)
            {
                SubPageLink = Job Card No.=FIELD(Job Card No.);
                SubPageView = SORTING(Job Card No.);
            }
            systempart(;Notes)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        JobDate := DT2DATE("Job Start Date");
        IF JobDate <> 0D THEN
          JobAge := TODAY - JobDate;
    end;

    var
        JobAge: Integer;
        JobDate: Date;
}

