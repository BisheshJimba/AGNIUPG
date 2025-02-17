table 33020550 "Attendance Log"
{
    //  -----jagesh maharjan<10-August-2013>
    // * Machine Emp. Code
    // * Employee Name
    // - Two fields Added
    //     validation of employee code will bring Employee code and Name in the record.

    DataPerCompany = true;

    fields
    {
        field(1; "Employee ID"; Code[20])
        {
            Editable = false;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF Employee.GET("Employee ID") THEN BEGIN
                    "Employee Name" := Employee."Full Name";
                    "Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := Employee."Global Dimension 2 Code";
                END
                ELSE BEGIN
                    "Shortcut Dimension 1 Code" := '';
                    "Shortcut Dimension 2 Code" := '';
                END;
            end;
        }
        field(2; Date; Date)
        {
            Editable = false;
        }
        field(3; Time; Time)
        {
            Editable = false;
        }
        field(4; MachineCode; Code[10])
        {
            TableRelation = "Attendance Machine Mapping";

            trigger OnValidate()
            begin
                IF AttMachineMap.GET(MachineCode) THEN
                    "Machine Center" := AttMachineMap."Responsibility Center"
                ELSE
                    "Machine Center" := '';
            end;
        }
        field(10; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(90; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(100; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(200; "Machine Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
        field(201; "Assigned User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(202; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(204; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(205; "Machine Emp. Code"; Code[10])
        {

            trigger OnValidate()
            begin
                EmpCodemapping.RESET;
                EmpCodemapping.SETRANGE("Employee Mapping Code", "Machine Emp. Code");
                IF EmpCodemapping.FINDFIRST THEN BEGIN
                    "Employee ID" := EmpCodemapping."Employee Code";
                    /*Employee.RESET;
                    Employee.SETRANGE("No.","Employee ID");
                    IF Employee.FINDFIRST THEN BEGIN
                       "Employee Name" := Employee."Full Name";
                       "Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
                       "Shortcut Dimension 2 Code" := Employee."Global Dimension 2 Code";
                     END */
                    //else

                END;

                "Creation Date" := TODAY;

            end;
        }
    }

    keys
    {
        key(Key1; "Machine Emp. Code", Date, Time, "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Assigned User ID" := USERID;
        "Creation Date" := TODAY;
    end;

    var
        Employee: Record "5200";
        AttMachineMap: Record "33020558";
        EmpCodemapping: Record "33020559";
        AttendanceLog: Record "33020550";
}

