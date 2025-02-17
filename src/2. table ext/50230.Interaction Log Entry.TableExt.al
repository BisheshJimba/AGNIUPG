tableextension 50230 tableextension50230 extends "Interaction Log Entry"
{
    // 30-07-2007 EDMS P3
    //   * New function DrillDownComment
    fields
    {

        //Unsupported feature: Property Modification (OptionString) on ""Document Type"(Field 30)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Contact Company Name"(Field 40)".

        field(50009; "Prospect Line No."; Integer)
        {
            Description = 'CNY.CRM Populate Pipeline Management Details for the Prospect';
            TableRelation = "Pipeline Management Details"."Line No." WHERE(Prospect No.=FIELD(Contact No.));
        }
        field(25006000;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(25006010;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006020;"Make Code";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Make Code" WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006021;Remarks;Text[150])
        {
        }
        field(25006030;"Model Code";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Model Code" WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006040;"Model Version No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Model Version No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Model Version No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006170;"Vehicle Registration No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Registration No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1;"Vehicle Serial No.")
        {
        }
    }


    //Unsupported feature: Code Modification on "ShowDocument(PROCEDURE 1)".

    //procedure ShowDocument();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CASE "Document Type" OF
          "Document Type"::"Sales Qte.":
            IF "Version No." <> 0 THEN BEGIN
        #4..42
          "Document Type"::"Sales Cr. Memo":
            BEGIN
              SalesCrMemoHeader.GET("Document No.");
              PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
            END;
          "Document Type"::"Sales Stmnt.":
            ERROR(Text003);
        #50..100
          "Document Type"::"Purch. Cr. Memo":
            BEGIN
              PurchCrMemoHeader.GET("Document No.");
              PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHeader);
            END;
          "Document Type"::"Cover Sheet":
            ERROR(Text004);
        #108..149
              PAGE.RUN(PAGE::"Service Quote",ServHeader);
            END;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..45
              PAGE.RUN(PAGE::"Posted Credit Note",SalesCrMemoHeader);
        #47..103
              PAGE.RUN(PAGE::"Posted Debit Note",PurchCrMemoHeader);
        #105..152
        */
    //end;

    procedure DrillDownComment()
    var
        Comm: Record "5123";
    begin
        Comm.SETRANGE("Entry No.","Entry No.");
        PAGE.RUN(PAGE::"Inter. Log Entry Comment Sheet",Comm);
    end;
}

