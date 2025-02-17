table 33020354 "Work Sheet Header"
{

    fields
    {
        field(1; "Employee ID"; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "Employee ID");
                IF EmpRec.FIND('-') THEN
                    "Employee Name" := EmpRec.Initials + ' ' + EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
            end;
        }
        field(2; Year; Integer)
        {
            NotBlank = true;
            TableRelation = "English Year".Code;
        }
        field(3; Month; Option)
        {
            NotBlank = true;
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;

            trigger OnValidate()
            begin
                /*
                WorkSheetLine.RESET;
                IF WorkSheetLine.FIND('+') THEN
                  LineNo := WorkSheetLine."Line No.";
                LineNo := LineNo + 1;
                
                CalenderRec.RESET;
                CalenderRec.SETRANGE(Year,Year);
                CalenderRec.SETRANGE(Month,Month);
                IF CalenderRec.FIND('-') THEN BEGIN
                  REPEAT
                    WorkSheetLine.INIT;
                    WorkSheetLine."Employee ID" := "Employee ID";
                    WorkSheetLine."Line No." := LineNo;
                    WorkSheetLine."Work Date" := CalenderRec.Date;
                    WorkSheetLine.Year := Year;
                    WorkSheetLine.Month := Month;
                    WorkSheetLine.Day := CalenderRec.Week;
                    WorkSheetLine.INSERT;
                    LineNo := LineNo + 1;
                  UNTIL CalenderRec.NEXT = 0;
                END;
                */

            end;
        }
        field(4; "User ID"; Code[20])
        {
            Enabled = false;
        }
        field(5; Completed; Boolean)
        {
        }
        field(6; "Completed Date"; Date)
        {
        }
        field(7; "Re-Opened Date"; Date)
        {
        }
        field(8; "Employee Name"; Text[120])
        {
        }
        field(9; Week; Integer)
        {
            NotBlank = true;
        }
        field(10; Designation; Text[50])
        {
            CalcFormula = Lookup(Employee.Designation WHERE(No.=FIELD(Employee ID)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Employee ID",Year,Month,Week)
        {
            Clustered = true;
        }
        key(Key2;Year)
        {
        }
        key(Key3;Month)
        {
        }
    }

    fieldgroups
    {
    }

    var
        CalenderRec: Record "33020302";
        LineNo: Integer;
        EmpRec: Record "5200";
        WorkSheetLine: Record "33020355";
}

