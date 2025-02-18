table 130416 "Vendor Line"
{

    fields
    {
        field(1; "Memo No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Vendor Code"; Code[20])
        {
            TableRelation = Vendor WHERE(Blocked = CONST(" "));

            trigger OnValidate()
            begin
                IF Vendor.GET("Vendor Code") THEN //aakrista 12/5/2021
                    "Vendor Name" := Vendor.Name;
                "Payment Terms Code" := Vendor."Payment Terms Code";
            end;
        }
        field(4; "Vendor Name"; Text[60])
        {
            Editable = false;
        }
        field(5; Quantity; Integer)
        {
        }
        field(6; Amount; Decimal)
        {
            Editable = false;
        }
        field(7; "Unit Cost"; Decimal)
        {

            trigger OnValidate()
            begin
                //Amount := Quantity * "Unit Cost";
                VALIDATE(Amount, Quantity * "Unit Cost");
            end;
        }
        field(50000; Description; Text[50])
        {
        }
        field(50001; "Payment Terms Code"; Code[20])
        {
            Editable = false;
        }
        field(50002; Selected; Boolean)
        {

            trigger OnValidate()
            begin
                ProcMemo.GET("Memo No.");
                IF Selected THEN BEGIN //Aakrista 5/17/2022
                    InsertBudgetAnalysis(ProcMemo);
                END ELSE BEGIN
                    ProcBud.RESET;
                    ProcBud.SETRANGE("Memo No.", "Memo No.");
                    IF ProcMemo."Procurement Type" = ProcMemo."Procurement Type"::Purchase THEN
                        ProcBud.SETRANGE("Vendor Code", "Vendor Code")
                    ELSE
                        IF ProcMemo."Procurement Type" = ProcMemo."Procurement Type"::Sales THEN
                            ProcBud.SETRANGE("Vendor Code", "Customer Code");
                    ProcBud.SETRANGE("G/L Account No.", "G/L Account No.");
                    ProcBud.SETRANGE("Global Dimension 1 Code", "Global Dimension 1 Code");
                    ProcBud.SETRANGE("Global Dimension 2 Code", "Global Dimension 2 Code");
                    IF ProcBud.FINDFIRST THEN
                        ProcBud.DELETE;
                END;

                /*VendorLines.RESET;//Aakrista 5/17/2022
                VendorLines.SETRANGE("Memo No.","Memo No.");
                VendorLines.SETRANGE(Selected,TRUE);
                IF VendorLines.FINDFIRST THEN BEGIN
                  IF NOT Selected THEN
                    ProcBud.RESET;
                    ProcBud.SETRANGE("Memo No.",VendorLines."Memo No.");
                    ProcBud.SETRANGE("Vendor Code",VendorLines."Vendor Code");
                    IF ProcBud.FINDFIRST THEN
                      ProcBud.DELETE;
                  END;*/

            end;
        }
        field(50003; Recommendation; Text[250])
        {
        }
        field(50004; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50005; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50006; "G/L Account No."; Code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            var
                GLBudgetEntry: Record "G/L Budget Entry";
            begin
                IF GlAccount.GET("G/L Account No.") THEN //Yougesh 6/8/2022
                    "G/L Account Name" := GlAccount.Name;
            end;
        }
        field(50007; "Incoming File"; BLOB)
        {
            SubType = UserDefined;
        }
        field(50008; Extension; Text[250])
        {
        }
        field(50009; "G/L Account Name"; Text[50])
        {
            Editable = false;
        }
        field(50012; "Customer Code"; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF CustomerName.GET("Customer Code") THEN BEGIN//Yougesh 6/9/2022
                    "Customer Name" := CustomerName.Name;
                    "Payment Terms Code" := CustomerName."Payment Method Code"
                END;
            end;
        }
        field(50013; "Customer Name"; Text[50])
        {
            Editable = false;
        }
        field(50014; "Chasis No."; Code[20])
        {

            trigger OnValidate()
            begin
                //Vehicle.GET("Chasis No.");
                //Vehicle.CALCFIELDS("Model Version No.");
            end;
        }
        field(50015; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Item."No." WHERE("Item Type" = CONST("Model Version"));

            trigger OnLookup()
            var
                recModelVersion: Record Item;
            begin
                //TESTFIELD("Make Code");
                //TESTFIELD("Model Code");
                /*recModelVersion.RESET;
                IF LookUpMgt.LookUpModelVersion(recModelVersion,"Model Version No.","Make Code","Model Code") THEN
                 VALIDATE("Model Version No.",recModelVersion."No.")*/

            end;

            trigger OnValidate()
            begin
                //TESTFIELD(Status,Status::Open);
                SalesPrice.RESET;
                SalesPrice.SETRANGE("Model Version No.", "Model Version No.");
                IF SalesPrice.FINDLAST THEN
                    "Current MRP" := SalesPrice."Unit Price";
            end;
        }
        field(50016; "Dealer Type"; Option)
        {
            OptionMembers = " ",Dealer,Showroom,Tender;
        }
        field(50017; "LC/PO Details"; Code[20])
        {
        }
        field(50018; "Customer Details"; Text[250])
        {
        }
        field(50019; "Current MRP"; Decimal)
        {
        }
        field(50020; "Old MRP"; Decimal)
        {

            trigger OnValidate()
            begin
                "Difference in MRP" := "Current MRP" - "Old MRP";//aakrista
            end;
        }
        field(50021; "Difference in MRP"; Decimal)
        {
        }
        field(50022; "Discount On Old Price"; Decimal)
        {
        }
        field(50023; "Discount On New Price"; Decimal)
        {
        }
        field(50024; "Billing Price"; Decimal)
        {
        }
        field(50025; "Model Year"; Text[50])
        {
        }
        field(50026; Remarks; Text[50])
        {
        }
        field(50027; "Model Code"; Code[20])
        {
        }
        field(50028; "Serial No."; Code[20])
        {

            trigger OnLookup()
            begin
                Vehicle.RESET;
                IF LookUpMgt.LookUpVehicleAMT(Vehicle, "Model Code", '', "Model Version No.") THEN BEGIN
                    VALIDATE("Serial No.", Vehicle."Serial No.");
                    //CALCFIELDS("Chasis No.");
                END;
            end;

            trigger OnValidate()
            begin
                Vehicle.RESET;
                Vehicle.SETRANGE("Serial No.", "Serial No.");
                IF Vehicle.FINDFIRST THEN BEGIN
                    "Chasis No." := Vehicle.VIN;
                    VALIDATE("Model Version No.", Vehicle."Model Version No.");
                    "Model Code" := Vehicle."Model Code";
                    "Model Year" := Vehicle."Production Year";
                END;
            end;
        }
        field(50029; Recommendation1; Text[250])
        {
        }
        field(50030; VIN; Code[20])
        {
        }
        field(50031; "1st Nego. Amount"; Decimal)
        {
        }
        field(50032; "2nd Nego. Amount"; Decimal)
        {
        }
        field(50033; "3rd Nego. Amount"; Decimal)
        {
        }
        field(50034; "Quotes Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Memo No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Vendor: Record Vendor;
        BudgetAnalysis: Record "Procurement Budget Analysis";
        BudgetAnalysis2: Record "Procurement Budget Analysis";
        VendorLines: Record "Vendor Line";
        ProcBud: Record "Procurement Budget Analysis";
        GlAccount: Record "G/L Account";
        CustomerName: Record Customer;
        ProcMemo: Record "Procurement Memo";
        Vehicle: Record Vehicle;
        LookUpMgt: Codeunit LookUpManagement;
        SalesPrice: Record "Sales Price";

    procedure GetNewLineNo(MemoNo: Code[20]): Integer
    var
        BudgetAnalysisProc: Record "Procurement Budget Analysis";
    begin
        BudgetAnalysisProc.RESET;
        BudgetAnalysisProc.SETRANGE("Memo No.", MemoNo);
        IF BudgetAnalysisProc.FINDLAST THEN;
        BudgetAnalysisProc."Line No." := BudgetAnalysisProc."Line No." + 1000;
        EXIT(BudgetAnalysisProc."Line No.");
    end;

    local procedure InsertBudgetAnalysis(ProcMemos: Record "Procurement Memo")
    begin
        BudgetAnalysis.RESET;
        BudgetAnalysis.SETRANGE("Memo No.", "Memo No.");
        IF ProcMemos."Procurement Type" = ProcMemos."Procurement Type"::Purchase THEN
            BudgetAnalysis.SETRANGE("Vendor Code", "Vendor Code")
        ELSE IF ProcMemos."Procurement Type" = ProcMemos."Procurement Type"::Sales THEN
            BudgetAnalysis.SETRANGE("Vendor Code", "Customer Code");//for sales vendor code is used as customer code
        BudgetAnalysis.SETRANGE("G/L Account No.", "G/L Account No.");
        BudgetAnalysis.SETRANGE("Global Dimension 1 Code", "Global Dimension 1 Code");
        BudgetAnalysis.SETRANGE("Global Dimension 2 Code", "Global Dimension 2 Code");
        BudgetAnalysis.SETRANGE("New Reccomendation", Amount);
        IF ProcMemos.VIN THEN
            BudgetAnalysis.SETRANGE(VIN, VIN);
        IF NOT BudgetAnalysis.FINDFIRST THEN
            REPEAT
                BudgetAnalysis.INIT;
                BudgetAnalysis."Memo No." := "Memo No.";
                BudgetAnalysis."Line No." := GetNewLineNo("Memo No.");
                IF ProcMemos."Procurement Type" = ProcMemos."Procurement Type"::Purchase THEN
                    BudgetAnalysis."Vendor Code" := "Vendor Code"
                ELSE IF ProcMemos."Procurement Type" = ProcMemos."Procurement Type"::Sales THEN
                    BudgetAnalysis."Vendor Code" := "Customer Code";
                BudgetAnalysis."Global Dimension 1 Code" := "Global Dimension 1 Code";
                BudgetAnalysis."Global Dimension 2 Code" := "Global Dimension 2 Code";
                BudgetAnalysis."New Reccomendation" := Amount;
                BudgetAnalysis.VIN := VIN;
                BudgetAnalysis.INSERT;
                BudgetAnalysis.VALIDATE("G/L Account No.", "G/L Account No.");
                BudgetAnalysis.VALIDATE("G/L Account Name", "G/L Account Name");//Yougesh
                BudgetAnalysis.MODIFY;
            UNTIL BudgetAnalysis.NEXT = 0;
    end;
}

