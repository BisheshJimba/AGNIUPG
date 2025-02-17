table 33020169 "Ins. Payment Memo Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; Description; Text[50])
        {
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(50000; "No. Series"; Code[10])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(50001; Posted; Boolean)
        {
            Editable = true;
        }
        field(50002; "Insurance Company Code"; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                CALCFIELDS("Insurance Company Name");
            end;
        }
        field(50003; "Insurance Company Name"; Text[50])
        {
            CalcFormula = Lookup(Vendor.Name WHERE(No.=FIELD(Insurance Company Code)));
                Editable = false;
                FieldClass = FlowField;
        }
        field(50004; "Posting Date"; Date)
        {
            Editable = false;
        }
        field(50005; "Document Date"; Date)
        {
        }
        field(50006; "Make Code"; Code[20])
        {
            TableRelation = Make.Code;
        }
        field(50007; "ShortCut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(50008; "ShortCut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(50009; OrderCreated; Boolean)
        {
        }
        field(50010; "Premium Amount"; Decimal)
        {
            CalcFormula = Sum("Ins. Payment Memo Line"."Insurance Basic" WHERE(No.=FIELD(No.)));
            FieldClass = FlowField;
        }
        field(50011;"Premium Amount Inc. VAT";Decimal)
        {
            CalcFormula = Sum("Ins. Payment Memo Line"."Ins. Prem Value (with VAT)" WHERE (No.=FIELD(No.)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ERROR('You cannot delete the Insurance Payment Memo.');
    end;

    trigger OnInsert()
    begin
        SalesSetup.GET;
        IF "No." = '' THEN BEGIN
          TestNoSeries;
          NoSeriesMngt.InitSeries(GetNoSeries,xRec."No. Series",0D,"No.","No. Series");
        END;
        "Document Date" := TODAY;
        "Posting Date" := TODAY;
    end;

    var
        NoSeriesMngt: Codeunit "396";
        STPLSysMngt: Codeunit "50000";
        SalesSetup: Record "311";

    [Scope('Internal')]
    procedure AssistEdit(xVehInsPayment: Record "33020169"): Boolean
    begin
        SalesSetup.GET;
        TestNoSeries;
        IF NoSeriesMngt.SelectSeries(GetNoSeries,xVehInsPayment."No. Series","No. Series") THEN BEGIN
          SalesSetup.GET;
          TestNoSeries;
          NoSeriesMngt.SetSeries("No.");
          EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    begin

        SalesSetup.TESTFIELD("Veh. Insurance Payment Nos.");
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
        EXIT(SalesSetup."Veh. Insurance Payment Nos.");
    end;

    [Scope('Internal')]
    procedure UpdateVehicleInsurance(var RecInsPayment: Record "33020169")
    var
        VehicleInsurance: Record "25006033";
        VehInsPaymentHeader: Record "33020169";
        VehInsPaymentLine: Record "33020170";
        Text000: Label 'Vehicle Insurance payment %1 (%2)  successfully posted.';
    begin
        RecInsPayment.TESTFIELD("Insurance Company Code");
        VehInsPaymentLine.RESET;
        VehInsPaymentLine.SETRANGE("No.",RecInsPayment."No.");
        IF VehInsPaymentLine.FINDSET THEN BEGIN
          REPEAT
            VehInsPaymentLine.TESTFIELD("Insurance Policy No.");
            VehicleInsurance.RESET;
            VehicleInsurance.SETCURRENTKEY("Insurance Policy No.");
            VehicleInsurance.SETRANGE("Insurance Policy No.",VehInsPaymentLine."Insurance Policy No.");
            VehicleInsurance.SETRANGE("Vehicle Serial No.",VehInsPaymentLine."Vehicle Serial No.");
            IF VehicleInsurance.FINDFIRST THEN BEGIN
              VehicleInsurance."Payment Memo Generated" := TRUE;
              VehicleInsurance.MODIFY;
            END;
          UNTIL VehInsPaymentLine.NEXT=0;
          RecInsPayment.Posted := TRUE;
          RecInsPayment."Posting Date" := TODAY;
          RecInsPayment.MODIFY;
          MESSAGE(Text000,RecInsPayment."No.",RecInsPayment."Insurance Company Name");
        END;
    end;
}

