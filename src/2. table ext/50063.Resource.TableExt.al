tableextension 50063 tableextension50063 extends Resource
{
    // 10.10.2016 EB.P7 #WSH16
    //   25006292"On Task Start"
    // 
    // 04.11.2013 EDMS P8
    //   * changed name of field 25006286
    fields
    {
        modify(Type)
        {
            OptionCaption = 'Person,Machine,Bay';

            //Unsupported feature: Property Modification (OptionString) on "Type(Field 2)".

        }
        modify(City)
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 27)".


        //Unsupported feature: Property Modification (CalcFormula) on "Capacity(Field 41)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Order (Job)"(Field 42)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. Quoted (Job)"(Field 43)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Usage (Qty.)"(Field 44)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Usage (Cost)"(Field 45)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Usage (Price)"(Field 46)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Sales (Qty.)"(Field 47)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Sales (Cost)"(Field 48)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Sales (Price)"(Field 49)".

        modify("Post Code")
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Assembly Order"(Field 900)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Service Order"(Field 5900)".


        //Unsupported feature: Property Modification (CalcFormula) on ""In Customer Zone"(Field 5902)".

        field(50001; "M Skill"; Code[20])
        {
            Description = 'PSF';
        }
        field(50002; "Resource Type"; Option)
        {
            OptionMembers = " ","Quality Control","Floor Control";
        }
        field(25006273; "Lunch Break Start Time"; Time)
        {
            Caption = 'Lunch Break Start Time';
            Description = 'Service Planner';
        }
        field(25006274; "Lunch Break End Time"; Time)
        {
            Caption = 'Lunch Break End Time';
            Description = 'Service Planner';
        }
        field(25006275; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            Description = 'Service Schedule';
            TableRelation = Employee;
        }
        field(25006276; "Serv. Schedule Password"; Text[20])
        {
            Caption = 'Serv. Schedule Password';
            Description = 'Service Schedule';
        }
        field(25006280; "Skill Level"; Integer)
        {
            BlankZero = true;
            Caption = 'Skill Level';
            Description = 'Service Planner';
        }
        field(25006282; "Date Time Filter"; Decimal)
        {
            Caption = 'Date Time Filter';
            Description = 'Service Schedule';
            FieldClass = FlowFilter;
        }
        field(25006286; "Service Work Group Code"; Code[20])
        {
            Caption = 'Service Work Group Code';
            TableRelation = "Service Work Group";
        }
        field(25006290; "Allow Simultaneous Work"; Boolean)
        {
            Caption = 'Allow Simultaneous Work';
        }
        field(25006291; "Non Productive Hours"; Decimal)
        {
            // FieldClass = FlowField;//no calcformula
        }
        field(25006292; "On Task Start"; Option)
        {
            OptionCaption = 'Do Nothing,Hold Other Tasks,Complete Other Tasks';
            OptionMembers = "Do Nothing","Hold Other Tasks","Complete Other Tasks";
        }
        field(33020235; "Is Bay"; Boolean)
        {
        }
        field(33020236; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center".Code;
        }
    }

    procedure FilterOnView(): Code[10]
    var
        UserSetup: Record "User Setup";
    begin
        IF UserSetup.GET(USERID) THEN BEGIN
            EXIT(UserSetup."Default Responsibility Center");
        END;
        EXIT('');
    end;

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".

}

