table 25006053 "Deal Application Entry"
{
    Caption = 'Deal Application Entry';

    fields
    {
        field(10; Type; Code[10])
        {
            Caption = 'Type';
            TableRelation = "Deal Application Type".No.;
        }
        field(20; "Det. Cust. Ledg. Entry EDMS"; Integer)
        {
            Caption = 'Det. Cust. Ledg. Entry EDMS';
        }
        field(30; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Posted Invoice,Posted C.Memo';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Posted Invoice","Posted C.Memo";
        }
        field(40; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = IF (Document Type=FILTER(<Posted Invoice)) "Sales Header".No. WHERE (Document Type=FIELD(Document Type))
                            ELSE IF (Document Type=CONST(Posted Invoice)) "Sales Invoice Header".No.
                            ELSE IF (Document Type=CONST(Posted C.Memo)) "Sales Cr.Memo Header".No.;
        }
        field(50;"Doc. Line No.";Integer)
        {
            Caption = 'Doc. Line No.';
            TableRelation = "Sales Line"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                           Document No.=FIELD(Document No.));
        }
        field(60;"Applies-to Entry No.";Integer)
        {
            Caption = 'Applies-to Entry No.';
        }
        field(70;Application;Boolean)
        {
            Caption = 'Application';
        }
        field(80;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
        }
    }

    keys
    {
        key(Key1;Type,"Det. Cust. Ledg. Entry EDMS","Document Type","Document No.","Doc. Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Applies-to Entry No.")
        {
        }
        key(Key3;"Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        LocDealApplEntry: Record "25006053";
    begin
        LocDealApplEntry.RESET;
        LocDealApplEntry.SETCURRENTKEY("Entry No.");
        IF LocDealApplEntry.FINDLAST THEN
          "Entry No." := LocDealApplEntry."Entry No." + 1
        ELSE
          "Entry No." := 1
    end;

    var
        DealApplEntry: Record "25006053";
        SalesLine: Record "37";
        DCLedgEntry: Record "25006054";
        Text001: Label 'There is more than one record with system type %1 in the table %2. Check Setup in the table %2.';
        Text002: Label 'Thers is no records with system type %1 in the table %2. Check Setup in the table %2.';

    [Scope('Internal')]
    procedure InitApplication(NewSysType: Option " ",Leasing;DCLedgEntryNo: Integer;DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";DocNo: Code[20];DocLineNo: Integer)
    var
        DealApplType: Record "25006055";
        ApplToEntry: Integer;
    begin
        DealApplType.SETRANGE("System Type",NewSysType);
        IF DealApplType.COUNT > 1 THEN
          ERROR(Text001,NewSysType,DealApplType.TABLECAPTION);
        IF NOT DealApplType.FINDFIRST THEN
          ERROR(Text002,NewSysType,DealApplType.TABLECAPTION);

        RESET;
        IF NOT GET(DealApplType."No.",DCLedgEntryNo,DocType,DocNo,DocLineNo) THEN BEGIN
          INIT;
          DealApplEntry.RESET;
          DealApplEntry.SETCURRENTKEY("Entry No.");
          IF DealApplEntry.FINDLAST THEN
            ApplToEntry := DealApplEntry."Entry No." + 1
          ELSE
            ApplToEntry := 1;
          "Applies-to Entry No." := 0;
          Type := DealApplType."No.";
          "Det. Cust. Ledg. Entry EDMS" := DCLedgEntryNo;
          "Document Type" := DocType;
          "Document No." := DocNo;
          "Doc. Line No." := DocLineNo;
        //  Application := TRUE;
          INSERT(TRUE);
          DealApplEntry := Rec;
          DealApplEntry."Applies-to Entry No." := FindDocs(Rec);
          IF DealApplEntry."Applies-to Entry No." <> 0 THEN
            ApplToEntry := DealApplEntry."Applies-to Entry No."
          ELSE
            DealApplEntry."Applies-to Entry No." := ApplToEntry;
          SETCURRENTKEY("Applies-to Entry No.");
          SETRANGE("Applies-to Entry No.",0);
          MODIFYALL("Applies-to Entry No.",ApplToEntry);
          Rec := DealApplEntry;
        END
    end;

    [Scope('Internal')]
    procedure FindDocs(NewDealApplEntry: Record "25006053") Result: Integer
    var
        SalesLine2: Record "37";
        VehSerialNo: Code[20];
        VehAccNo: Code[20];
    begin
        DCLedgEntry.RESET;
        IF NewDealApplEntry."Det. Cust. Ledg. Entry EDMS" = 0 THEN BEGIN
          SalesLine.GET(NewDealApplEntry."Document Type",NewDealApplEntry."Document No.",NewDealApplEntry."Doc. Line No.");
          SalesLine.TESTFIELD("Vehicle Serial No.");
          SalesLine.TESTFIELD("Vehicle Accounting Cycle No.");
          VehSerialNo := SalesLine."Vehicle Serial No.";
          VehAccNo := SalesLine."Vehicle Accounting Cycle No.";
        END ELSE BEGIN
          DCLedgEntry.GET(NewDealApplEntry."Det. Cust. Ledg. Entry EDMS");
          VehSerialNo := DCLedgEntry."Vehicle Serial No.";
          VehAccNo := DCLedgEntry."Vehicle Accounting Cycle No.";
          DCLedgEntry.SETFILTER("Entry No.",'<>%1',DCLedgEntry."Entry No.");
        END;
        DCLedgEntry.SETRANGE("Vehicle Serial No.",VehSerialNo);
        DCLedgEntry.SETRANGE("Vehicle Accounting Cycle No.",VehAccNo);
        SETCURRENTKEY(Type,"Det. Cust. Ledg. Entry EDMS","Document Type","Document No.","Doc. Line No.");
        IF DCLedgEntry.FINDSET THEN
          REPEAT
            INIT;
            Type := NewDealApplEntry.Type;
            "Document Type" := DCLedgEntry."Document Type" + 4;
            "Document No." := DCLedgEntry."Document No.";
            "Doc. Line No." := DCLedgEntry."Document Line No.";
            "Applies-to Entry No." := NewDealApplEntry."Applies-to Entry No.";
            "Det. Cust. Ledg. Entry EDMS" := DCLedgEntry."Entry No.";
            IF FINDFIRST THEN
              Result := "Applies-to Entry No."
            ELSE
              INSERT(TRUE);
          UNTIL DCLedgEntry.NEXT = 0;

        SalesLine2.SETRANGE("Vehicle Serial No.",VehSerialNo);
        SalesLine2.SETRANGE("Vehicle Accounting Cycle No.",VehAccNo);
        IF SalesLine2.FINDSET THEN
          REPEAT
            INIT;
            Type := NewDealApplEntry.Type;
            "Document Type" := SalesLine2."Document Type";
            "Document No." := SalesLine2."Document No.";
            "Doc. Line No." := SalesLine2."Line No.";
            "Applies-to Entry No." := NewDealApplEntry."Applies-to Entry No.";
            "Det. Cust. Ledg. Entry EDMS" := 0;
            IF INSERT(TRUE) THEN;
          UNTIL SalesLine2.NEXT = 0;
    end;
}

