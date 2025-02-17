pageextension 50113 pageextension50113 extends "Recurring General Journal"
{
    // 06.05.2014 Elva Baltic P8 #0039 MMG7.00
    //   * Added fields:
    //     "Vehicle Serial No." .. "Source No."
    // 
    // 28.02.2014 Elva Baltic P7 #F194 MMG7.00
    //   * Added new field "Accounting Information"
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = true;
    Editable = true;
    Editable = true;
    Editable = true;
    Editable = true;
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".

        addafter("Control 14")
        {
            field("Account Name"; "Account Name")
            {
            }
            field("Document Class"; "Document Class")
            {
            }
            field("Document Subclass"; "Document Subclass")
            {
            }
        }
        addafter("Control 16")
        {
            field(Narration; Narration)
            {
            }
        }
        addafter("Control 300")
        {
            field("Employee Name"; EmployeeName)
            {
                Editable = false;
            }
        }
        addafter("Control 3")
        {
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
                Visible = false;
            }
            field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
            {
                Visible = false;
            }
            field(VIN; VIN)
            {
                Visible = false;
            }
            field("Make Code"; "Make Code")
            {
                Visible = false;
            }
            field("Source Type"; Rec."Source Type")
            {
                Visible = false;
            }
            field("Source No."; Rec."Source No.")
            {
                Visible = false;
            }
            field("Cost Type"; "Cost Type")
            {
            }
            field("Line No."; Rec."Line No.")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 84".

    }

    var
        EmployeeName: Text[50];
        DimName: Record "349";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);
    //AGNI2017CU8 >>
    DimName.RESET;
    DimName.SETRANGE("Dimension Code",'Employee');
    DimName.SETRANGE(Code,ShortcutDimCode[3]);
    IF DimName.FINDFIRST THEN
      EmployeeName := DimName.Name
    ELSE
      EmployeeName := '';
    //AGNI2017CU8 <<
    */
    //end;
}

