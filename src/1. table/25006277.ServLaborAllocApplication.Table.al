table 25006277 "Serv. Labor Alloc. Application"
{
    // 12.05.2015 EB.P30 #T030
    //   Added fields:
    //     "Finished Cost Amount"
    //     "Remaining Cost Amount"
    //     "Total Cost Amount"
    // 
    // 12.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified OptionCaptionML property for field:
    //     "Document Type"
    // 
    // 2012.04.02 EDMS P8
    //   * add code to be used separatly from SS add-on
    // 
    // 10.01.2008. EDMS P2
    //   * Added field "Resource No."

    Caption = 'Serv. Labor Alloc. Application';
    DrillDownPageID = 25006374;
    LookupPageID = 25006374;

    fields
    {
        field(1; "Allocation Entry No."; Integer)
        {
            Caption = 'Allocation Entry No.';
            TableRelation = "Serv. Labor Allocation Entry";
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Return Order,Invoice,Credit Memo,Blanket Order,Booking';
            OptionMembers = Quote,"Order","Return Order",Invoice,"Credit Memo","Blanket Order",Booking;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            NotBlank = true;
            TableRelation = Resource;

            trigger OnValidate()
            var
                Resource: Record "156";
            begin
                Resource.GET("Resource No.");
                VALIDATE("Unit Cost", Resource."Unit Cost");
            end;
        }
        field(20; "Finished Quantity (Hours)"; Decimal)
        {
            Caption = 'Finished Quantity (Hours)';

            trigger OnValidate()
            begin
                VALIDATE("Finished Cost Amount", "Finished Quantity (Hours)" * "Unit Cost");
            end;
        }
        field(30; "Remaining Quantity (Hours)"; Decimal)
        {
            Caption = 'Remaining Quantity (Hours)';

            trigger OnValidate()
            begin
                VALIDATE("Remaining Cost Amount", "Remaining Quantity (Hours)" * "Unit Cost");
            end;
        }
        field(40; "Time Line"; Boolean)
        {
            Caption = 'Time Line';
        }
        field(50; Posted; Boolean)
        {
            Caption = 'Posted';
        }
        field(60; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';

            trigger OnValidate()
            begin
                VALIDATE("Finished Cost Amount", "Finished Quantity (Hours)" * "Unit Cost");
                VALIDATE("Remaining Cost Amount", "Remaining Quantity (Hours)" * "Unit Cost");
            end;
        }
        field(70; "Finished Cost Amount"; Decimal)
        {
            Caption = 'Finished Cost Amount';

            trigger OnValidate()
            begin
                "Cost Amount" := "Finished Cost Amount" + "Remaining Cost Amount";
            end;
        }
        field(80; "Remaining Cost Amount"; Decimal)
        {
            Caption = 'Remaining Cost Amount';

            trigger OnValidate()
            begin
                "Cost Amount" := "Finished Cost Amount" + "Remaining Cost Amount";
            end;
        }
        field(90; "Cost Amount"; Decimal)
        {
            Caption = 'Total Cost Amount';
        }
        field(120; Travel; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Allocation Entry No.", "Document Type", "Document No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Finished Quantity (Hours)", "Remaining Quantity (Hours)";
        }
        key(Key2; "Document Type", "Document No.")
        {
            SumIndexFields = "Finished Quantity (Hours)", "Remaining Quantity (Hours)";
        }
        key(Key3; "Document Type", "Document No.", "Document Line No.")
        {
            SumIndexFields = "Finished Quantity (Hours)", "Remaining Quantity (Hours)";
        }
        key(Key4; "Document Type", "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Found: Boolean;
    begin
        ServLaborAllocApplication.RESET;
        ServLaborAllocApplication.SETRANGE("Allocation Entry No.", "Allocation Entry No.");
        IF ServLaborAllocApplication.COUNT = 1 THEN
            IF ServLaborAllocationEntry.GET("Allocation Entry No.") THEN
                ServLaborAllocationEntry.DELETE;

        // 18.12.2014 Elva Baltic P21 #E0003 >>
        // Need to pass time line to other
        IF "Time Line" AND (ServLaborAllocApplication.COUNT > 1) THEN BEGIN
            ServLaborAllocApplication.FINDSET(TRUE);
            REPEAT
                IF NOT ((ServLaborAllocApplication."Allocation Entry No." = "Allocation Entry No.") AND
                        (ServLaborAllocApplication."Document Type" = "Document Type") AND
                        (ServLaborAllocApplication."Document No." = "Document No.") AND
                        (ServLaborAllocApplication."Document Line No." = "Document Line No.") AND
                        (ServLaborAllocApplication."Line No." = "Line No.")) THEN BEGIN
                    Found := TRUE;
                    ServLaborAllocApplication."Time Line" := TRUE;
                    ServLaborAllocApplication."Remaining Quantity (Hours)" := "Remaining Quantity (Hours)";
                    ServLaborAllocApplication."Finished Quantity (Hours)" := "Finished Quantity (Hours)";
                    ServLaborAllocApplication.MODIFY(TRUE);
                END;
            UNTIL Found OR (ServLaborAllocApplication.NEXT = 0);
        END;
        // 18.12.2014 Elva Baltic P21 #E0003 <<
    end;

    trigger OnInsert()
    begin
        //2012.04.02 EDMS P8 >>
        IF "Line No." = 0 THEN
            "Line No." := 10000;
        //IF "Allocation Entry No." = 0 THEN BEGIN
        IF ServLaborAllocApplication.GET("Allocation Entry No.", "Document Type", "Document No.", "Document Line No.",
            "Line No.") THEN BEGIN
            ServLaborAllocApplication.RESET;
            ServLaborAllocApplication.SETRANGE("Allocation Entry No.", "Allocation Entry No.");
            ServLaborAllocApplication.SETRANGE("Document Type", "Document Type");
            ServLaborAllocApplication.SETRANGE("Document No.", "Document No.");
            ServLaborAllocApplication.SETRANGE("Document Line No.", "Document Line No.");
            IF ServLaborAllocApplication.FINDLAST THEN
                "Line No." := ServLaborAllocApplication."Line No.";
            "Line No." += 10000;
        END;
        //2012.04.02 EDMS P8 <<
    end;

    var
        ServLaborAllocApplication: Record "25006277";
        ServLaborAllocationEntry: Record "25006271";
}

