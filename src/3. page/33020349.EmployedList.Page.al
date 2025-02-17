page 33020349 "Employed List"
{
    CardPageID = "Application Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020330;
    SourceTableView = SORTING(No.)
                      ORDER(Ascending)
                      WHERE(Employed = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Mobile No."; "Mobile No.")
                {
                }
                field(Email; Email)
                {
                }
                field(Status; Status)
                {
                }
                field("Vacancy No."; "Vacancy No.")
                {
                }
                field("Employed Date"; "Employed Date")
                {
                }
                field("Add. Employed Date"; "Add. Employed Date")
                {
                }
                field("Employee Number"; EmployeeNo)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin

        EmployeeRec.SETRANGE("Applicant No.", "No.");
        IF EmployeeRec.FIND('-') THEN
            EmployeeNo := EmployeeRec."No.";
    end;

    var
        EmployeeNo: Code[10];
        EmployeeRec: Record "5200";
}

