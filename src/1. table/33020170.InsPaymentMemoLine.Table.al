table 33020170 "Ins. Payment Memo Line"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
            TableRelation = "Ins. Payment Memo Header".No.;
        }
        field(2; "Chasis No."; Code[20])
        {
            Editable = false;

            trigger OnLookup()
            var
                recSalesRecSetup: Record "311";
                LookUpMgt: Codeunit "25006003";
                VehInsurance: Record "25006033";
            begin
                recVehInsurance.RESET;
                recVehInsPaymentHeader.RESET;
                recVehInsPaymentHeader.SETRANGE("No.", "No.");
                recVehInsPaymentHeader.FINDFIRST;
                recVehInsurance.SETRANGE("Ins. Company Code", recVehInsPaymentHeader."Insurance Company Code");
                recVehInsurance.SETRANGE("Payment Memo Generated", FALSE);
                recVehInsurance.SETRANGE("Proceed for Ins. Payment", FALSE);
                recVehInsurance.SETRANGE("Insured by Customer", FALSE);
                recVehInsurance.SETRANGE("Insured by Veh. Finance Dept.", FALSE);

                /*
                IF recVehInsurance.FINDSET THEN BEGIN
                  REPEAT
                    recVehInsurance2.RESET;
                    recVehInsurance2.SETCURRENTKEY("Insurance Policy No.");
                    recVehInsurance2.SETRANGE("Insurance Policy No.",recVehInsurance."Insurance Policy No.");
                    IF recVehInsurance2.FINDFIRST THEN
                      recVehInsurance2.MARK(TRUE);
                  UNTIL recVehInsurance.NEXT=0;
                END;
                */

                IF LookUpVehInsurance(recVehInsurance, recVehInsurance.VIN) THEN BEGIN
                    recVehInsurance.CALCFIELDS(VIN);
                    VALIDATE("Chasis No.", recVehInsurance.VIN);
                    VehInsurance.RESET;
                    VehInsurance.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
                    VehInsurance.SETRANGE("Insurance Policy No.", recVehInsurance."Insurance Policy No.");
                    IF VehInsurance.FINDFIRST THEN BEGIN
                        VehInsurance."Proceed for Ins. Payment" := TRUE;
                        VehInsurance.MODIFY;
                    END;
                    Paid := recVehInsurance.Paid;
                    "Payment Date" := recVehInsurance."Payment Date";
                    "Paid by Check#" := recVehInsurance."Paid by Check No.";
                    Cancelled := recVehInsurance.Cancelled;
                    "Cancellation Date" := recVehInsurance."Cancellation Date";
                    "Ins. Company Code" := recVehInsurance."Ins. Company Code";
                    TESTFIELD("Ins. Company Code");
                    "Bill No." := recVehInsurance."Bill No.";
                    "Bill Date" := recVehInsurance."Bill Date";
                    "Ins. Prem Value (with VAT)" := recVehInsurance."Ins. Prem Value (with VAT)";
                    "Insurance Basic" := recVehInsurance."Insurance Basic" + recVehInsurance."Other Insurance";
                    "Other Insurance" := recVehInsurance."Other Insurance";
                    "VAT(Insurance)" := recVehInsurance."VAT(Insurance)";
                    "Proforma Invoice No" := recVehInsurance."Proforma Invoice No";
                    VALIDATE("Insurance Policy No.", recVehInsurance."Insurance Policy No.");
                    TESTFIELD("Insurance Policy No.");
                    Description := recVehInsurance.Description;
                    "Customer Code" := recVehInsurance."Customer Code";
                    "Starting Date" := recVehInsurance."Starting Date";
                    "Ending Date" := recVehInsurance."Ending Date";
                    Type := recVehInsurance.Type;

                END;

            end;

            trigger OnValidate()
            begin
                //Retrieving vehicle information.
                DuplicateVINAllowed("Chasis No.");
                GblVehicle.RESET;
                GblVehicle.SETRANGE(VIN, "Chasis No.");
                IF GblVehicle.FIND('-') THEN BEGIN
                    "Engine No." := GblVehicle."Engine No.";
                    Model := GblVehicle."Model Code";
                    "Model Version" := GblVehicle."Model Version No.";
                    "Vehicle Serial No." := GblVehicle."Serial No.";
                END;
            end;
        }
        field(3; "Engine No."; Code[20])
        {
            Editable = false;
        }
        field(4; "DRP No."; Code[20])
        {
            Enabled = false;
        }
        field(5; Model; Code[20])
        {
            TableRelation = Model.Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Model Description");
            end;
        }
        field(6; "Model Description"; Text[50])
        {
            CalcFormula = Lookup(Model."Commercial Name" WHERE(Code = FIELD(Model)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Model Version"; Code[20])
        {

            trigger OnLookup()
            begin
                /*
                GblItem.RESET;
                IF GblLookupMgt.LookUpModelVersion(GblItem,"Model Version",'TATA',Model) THEN
                 VALIDATE("Model Version",GblItem."No.");
                */

            end;

            trigger OnValidate()
            begin
                CALCFIELDS("Model Description");
            end;
        }
        field(8; "Model Version Desc."; Text[50])
        {
            CalcFormula = Lookup(Item.Description WHERE(Item Type=CONST(Model Version),
                                                         Model Code=FIELD(Model),
                                                         No.=FIELD(Model Version)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;Amount;Decimal)
        {
        }
        field(10;"Vehicle Serial No.";Code[20])
        {
            TableRelation = Vehicle;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                recInsMemoLine: Record "33020166";
            begin
                recInsMemoLine.RESET;
                recInsMemoLine.SETRANGE(recInsMemoLine."Vehicle Serial No.","Vehicle Serial No.");
                recInsMemoLine.SETRANGE(recInsMemoLine.Canceled,FALSE);
                IF recInsMemoLine.FINDFIRST THEN
                   ERROR('Chesis no already exists in the Insurance memo no '+recInsMemoLine."Reference No.")
            end;
        }
        field(11;Canceled;Boolean)
        {
        }
        field(12;Ton;Decimal)
        {
            CalcFormula = Lookup(Item.Ton WHERE (No.=FIELD(Model Version)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13;CC;Integer)
        {
            CalcFormula = Lookup(Item.CC WHERE (No.=FIELD(Model Version)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14;"Seat Capacity";Integer)
        {
            CalcFormula = Lookup(Item."Seat Capacity" WHERE (No.=FIELD(Model Version)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001;Paid;Boolean)
        {
            Editable = false;
        }
        field(50002;"Payment Date";Date)
        {
            Editable = false;
        }
        field(50003;"Paid by Check#";Code[30])
        {
            Editable = false;
        }
        field(50004;Cancelled;Boolean)
        {
            Editable = true;
        }
        field(50005;"Cancellation Date";Date)
        {
            Editable = false;
        }
        field(50006;"DRP/ARE-1 No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."DRP No./ARE1 No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007;"Ins. Company Code";Code[20])
        {
            Editable = false;
            NotBlank = true;
            TableRelation = Vendor.No.;
        }
        field(50008;"Ins. Company Name";Text[50])
        {
            CalcFormula = Lookup(Vendor.Name WHERE (No.=FIELD(Ins. Company Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009;"Bill No.";Code[20])
        {
            Editable = false;
        }
        field(50010;"Bill Date";Date)
        {
            Editable = false;
        }
        field(50011;"Customer Name";Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE (No.=FIELD(Customer Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012;"Ins. Prem Value (with VAT)";Decimal)
        {
            Editable = false;
        }
        field(50013;"Insurance Basic";Decimal)
        {
            Editable = false;
        }
        field(50014;"Other Insurance";Decimal)
        {
            Editable = false;
        }
        field(50015;"VAT(Insurance)";Decimal)
        {
            Editable = false;
        }
        field(50016;"Proforma Invoice No";Code[20])
        {
            Editable = false;
        }
        field(50018;"Insurance Policy No.";Code[50])
        {
            Caption = 'Insurance Policy No.';
            Editable = false;
            NotBlank = true;

            trigger OnValidate()
            begin
                IF DuplicatePolicyNo("Insurance Policy No.") THEN
                  ERROR(Text000);
            end;
        }
        field(50019;Description;Text[30])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(50020;"Customer Code";Code[20])
        {
            Caption = 'Customer Code';
            Editable = false;
            TableRelation = Customer;
        }
        field(50021;"Starting Date";Date)
        {
            Caption = 'Starting Date';
            Editable = false;
            NotBlank = true;
        }
        field(50022;"Ending Date";Date)
        {
            Caption = 'Ending Date';
            Editable = false;
        }
        field(50023;Type;Code[20])
        {
            Caption = 'Type';
            Editable = false;
            NotBlank = true;
            TableRelation = "Vehicle Insurance Type";
        }
        field(50024;"Reason for Cancellation";Text[50])
        {
            Editable = false;
        }
        field(50025;"Order Created";Boolean)
        {
            CalcFormula = Lookup("Ins. Payment Memo Header".OrderCreated WHERE (No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"No.","Chasis No.","Insurance Policy No.")
        {
            Clustered = true;
            SumIndexFields = "Insurance Basic";
        }
        key(Key2;"Insurance Policy No.")
        {
        }
        key(Key3;"No.",Cancelled)
        {
            SumIndexFields = "Ins. Prem Value (with VAT)";
        }
        key(Key4;"Vehicle Serial No.",Cancelled)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        VehInsurance: Record "25006033";
    begin
        VehInsPayHeader.RESET;
        VehInsPayHeader.SETRANGE("No.","No.");
        IF VehInsPayHeader.FINDFIRST THEN BEGIN
          IF NOT VehInsPayHeader.Posted THEN BEGIN
            VehInsurance.RESET;
            //VehInsurance.SETRANGE("Vehicle Serial No.","Vehicle Serial No.");
            VehInsurance.SETRANGE("Insurance Policy No.","Insurance Policy No.");
            IF VehInsurance.FINDSET THEN BEGIN
            REPEAT
               VehInsurance."Proceed for Ins. Payment" := FALSE;
               VehInsurance.MODIFY;
            UNTIL VehInsurance.NEXT =0;
            END;
          END
          ELSE
            ERROR('You cannot delete posted Insurance Memo Line.');
        END
    end;

    var
        recVehicle: Record "25006005";
        GblVehicle: Record "25006005";
        LookUpMgt: Codeunit "25006003";
        recVehInsurance: Record "25006033";
        recVehInsPaymentHeader: Record "33020169";
        recVehInsurance2: Record "25006033";
        Text000: Label 'Duplicate Policy No. is not allowed.';
        Text001: Label 'VIN %1 is already %2 on Document %3.';
        VehInsPayHeader: Record "33020169";

    [Scope('Internal')]
    procedure LookUpVehInsurance(var recVehInsurance: Record "25006033";codCode: Code[20]): Boolean
    var
        frmVehInsurance: Page "25006053";
    begin
        CLEAR(frmVehInsurance);
        IF codCode <> '' THEN
         IF recVehInsurance.GET(codCode) THEN
          frmVehInsurance.SETRECORD(recVehInsurance);
        frmVehInsurance.SETTABLEVIEW(recVehInsurance);
        frmVehInsurance.LOOKUPMODE(TRUE);
        IF frmVehInsurance.RUNMODAL = ACTION::LookupOK THEN
         BEGIN
          frmVehInsurance.GETRECORD(recVehInsurance);
          EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure DuplicatePolicyNo(PolicyNo: Code[50]): Boolean
    var
        InsPolicyLine: Record "33020170";
        InsPolicyHeader: Record "33020169";
    begin
        InsPolicyLine.RESET;
        InsPolicyLine.SETCURRENTKEY("Insurance Policy No.");
        InsPolicyLine.SETRANGE("Insurance Policy No.",PolicyNo);
        InsPolicyLine.SETRANGE(Cancelled,FALSE);
        IF InsPolicyLine.FINDSET THEN BEGIN
          InsPolicyHeader.GET(InsPolicyLine."No.");
          IF InsPolicyHeader.Posted THEN
            EXIT(FALSE)
          ELSE
            EXIT(TRUE)
        END
        ELSE
          EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure DuplicateVINAllowed(VINCode: Code[20])
    var
        InsPolicyLine: Record "33020170";
        InsPolicyHeader: Record "33020169";
    begin
        /*InsPolicyLine.RESET;
        InsPolicyLine.SETRANGE("Chasis No.",VINCode);
        IF InsPolicyLine.FINDFIRST THEN BEGIN
          IF InsPolicyLine.Cancelled THEN BEGIN
          END
          ELSE BEGIN
            InsPolicyHeader.RESET;
            InsPolicyHeader.SETRANGE("No.",InsPolicyLine."No.");
            IF InsPolicyHeader.FINDFIRST THEN BEGIN
              IF InsPolicyHeader.Posted THEN
                ERROR(Text001,InsPolicyLine."Chasis No.",'Posted',InsPolicyHeader."No.")
              ELSE
                ERROR(Text001,InsPolicyLine."Chasis No.",'Exists',InsPolicyHeader."No.");
            END;
          END;
        END;
        */

    end;
}

