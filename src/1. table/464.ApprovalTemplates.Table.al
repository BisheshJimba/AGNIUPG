table 464 "Approval Templates"
{
    Caption = 'Approval Templates';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            Editable = false;
        }
        field(2; "Approval Code"; Code[20])
        {
            Caption = 'Approval Code';
            TableRelation = "Approval Code".Code;

            trigger OnValidate()
            var
                ApprCode: Record "Approval Code";
            begin
                TESTFIELD(Enabled, FALSE);
                ApprCode.GET("Approval Code");
                ApprCode.TESTFIELD("Linked To Table No.");
                "Table ID" := ApprCode."Linked To Table No.";
            end;
        }
        field(3; "Approval Type"; Option)
        {
            Caption = 'Approval Type';
            OptionCaption = ' ,Sales Pers./Purchaser,Approver';
            OptionMembers = " ","Sales Pers./Purchaser",Approver;

            trigger OnValidate()
            begin
                TESTFIELD(Enabled, FALSE);
            end;
        }
        field(4; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None";

            trigger OnValidate()
            begin
                TESTFIELD(Enabled, FALSE);
            end;
        }
        field(5; "Limit Type"; Option)
        {
            Caption = 'Limit Type';
            OptionCaption = 'Approval Limits,Credit Limits,Request Limits,No Limits';
            OptionMembers = "Approval Limits","Credit Limits","Request Limits","No Limits";

            trigger OnValidate()
            begin
                TESTFIELD(Enabled, FALSE);
            end;
        }
        field(6; "Additional Approvers"; Boolean)
        {
            Caption = 'Additional Approvers';
            Editable = false;
            FieldClass = FlowField;
            // CalcFormula = Exist("Additional Approvers" WHERE("Approval Code"=FIELD(Approval Code),
            //                                                   Approval Type=FIELD(Approval Type),
            //                                                   Document Type=FIELD(Document Type),
            //                                                   Limit Type=FIELD(Limit Type),
            //                                                   Approver ID=FILTER(<>'')));
            CalcFormula = exist("Additional Approvers" where("Approval Code" = field("Approval Code"), "Approval Type" = field("Approval Type"), "Document Type" = field("Document Type"), "Limit Type" = field("Limit Type"), "Approver ID" = filter(<> '')));
        }
        field(7; Enabled; Boolean)
        {
            Caption = 'Enabled';

            trigger OnValidate()
            var
                Salesheader: Record "Sales Header";
                PurchaseHeader: Record "Purchase Header";
                ApprovalEntry: Record "Approval Entry";
                TempApprovalTemplate: Record "Approval Templates";
            begin
                IF (Enabled = FALSE) AND (xRec.Enabled = TRUE) THEN BEGIN
                    TempApprovalTemplate.SETRANGE("Approval Code", "Approval Code");
                    TempApprovalTemplate.SETRANGE("Document Type", "Document Type");
                    IF NOT TempApprovalTemplate.FINDFIRST THEN
                        CASE "Table ID" OF
                            DATABASE::"Sales Header":
                                BEGIN
                                    Salesheader.SETCURRENTKEY("Document Type", Status);
                                    Salesheader.SETRANGE("Document Type", "Document Type");
                                    Salesheader.SETRANGE(Status, Salesheader.Status::"Pending Approval");
                                    IF Salesheader.FINDFIRST THEN BEGIN
                                        IF CONFIRM(Text006) THEN BEGIN
                                            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Sales Header");
                                            ApprovalEntry.SETRANGE("Document Type", "Document Type");
                                            ApprovalEntry.SETFILTER(
                                              Status, '%1|%2|%3', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open, ApprovalEntry.Status::Approved);
                                            IF ApprovalEntry.FINDFIRST THEN
                                                ApprovalEntry.MODIFYALL(Status, ApprovalEntry.Status::Canceled);
                                        END;
                                        Salesheader.MODIFYALL(Status, Salesheader.Status::Open);
                                    END;
                                END;
                            DATABASE::"Purchase Header":
                                BEGIN
                                    PurchaseHeader.SETCURRENTKEY("Document Type", Status);
                                    PurchaseHeader.SETRANGE("Document Type", "Document Type");
                                    PurchaseHeader.SETRANGE(Status, PurchaseHeader.Status::"Pending Approval");
                                    IF PurchaseHeader.FINDFIRST THEN BEGIN
                                        IF CONFIRM(Text006) THEN BEGIN
                                            ApprovalEntry.SETRANGE("Table ID", DATABASE::"Purchase Header");
                                            ApprovalEntry.SETRANGE("Document Type", "Document Type");
                                            ApprovalEntry.SETFILTER(
                                              Status, '%1|%2|%3', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open, ApprovalEntry.Status::Approved);
                                            IF ApprovalEntry.FINDFIRST THEN
                                                ApprovalEntry.MODIFYALL(Status, ApprovalEntry.Status::Canceled);
                                        END;
                                        PurchaseHeader.MODIFYALL(Status, Salesheader.Status::Open);
                                    END;
                                END;
                        END;
                END;

                IF "Approval Type" = "Approval Type"::" " THEN BEGIN
                    CALCFIELDS("Additional Approvers");
                    IF NOT "Additional Approvers" AND Enabled THEN
                        ERROR(STRSUBSTNO(Text005, FIELDCAPTION("Approval Type")));
                END;
                IF ("Approval Type" <> "Approval Type"::" ") AND ("Limit Type" = "Limit Type"::"Credit Limits") THEN BEGIN
                    CALCFIELDS("Additional Approvers");
                    IF NOT "Additional Approvers" AND Enabled THEN
                        ERROR(STRSUBSTNO(Text007, FIELDCAPTION("Approval Type"), FORMAT("Approval Type"),
                            FIELDCAPTION("Limit Type")));
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Approval Code", "Approval Type", "Document Type", "Limit Type")
        {
            Clustered = true;
        }
        key(Key2; "Table ID", "Approval Type", Enabled)
        {
        }
        key(Key3; "Approval Code", "Approval Type", Enabled)
        {
        }
        key(Key4; Enabled)
        {
        }
        key(Key5; "Limit Type", "Document Type", "Approval Type", Enabled)
        {
        }
        key(Key6; "Table ID", "Document Type", Enabled)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        AdditionalApprovers.SETRANGE("Approval Code", "Approval Code");
        AdditionalApprovers.SETRANGE("Approval Type", "Approval Type");
        AdditionalApprovers.SETRANGE("Document Type", "Document Type");
        AdditionalApprovers.SETRANGE("Limit Type", "Limit Type");
        AdditionalApprovers.DELETEALL;
    end;

    trigger OnInsert()
    begin
        TestValidation;
    end;

    trigger OnRename()
    begin
        TestValidation;
        RenameAddApprovers(Rec, xRec);
    end;

    var
        ApprCode: Record "Approval Code";
        AdditionalApprovers: Record "Additional Approvers";
        Text001: Label '%1 is not a valid limit type for table %2.';
        Text002: Label '%1 is only valid for table %2.';
        Text004: Label '%1 is only valid when document type is Quote and Table ID is %2.';
        Text005: Label 'Additional Approvers must be inserted if %1 is blank.';
        Text006: Label 'Do you want to cancel all outstanding approvals? ';
        Text007: Label 'Additional Approvers must be inserted if %1 is %2 and %3 is Credit Limit.';

    //[Scope('Internal')]
    procedure TestValidation()
    var
        AppSetup: Record "Approval Setup";
    begin
        AppSetup.GET;
        IF ("Table ID" = DATABASE::"Purchase Header") AND
           ("Limit Type" = "Limit Type"::"Credit Limits")
        THEN
            ERROR(STRSUBSTNO(Text001, FORMAT("Limit Type"), DATABASE::"Purchase Header"));

        IF ("Table ID" <> DATABASE::"Purchase Header") AND
           ("Limit Type" = "Limit Type"::"Request Limits")
        THEN
            ERROR(STRSUBSTNO(Text002, FORMAT("Limit Type"), DATABASE::"Purchase Header"));

        IF ("Table ID" = DATABASE::"Purchase Header") AND
           ("Limit Type" = "Limit Type"::"Request Limits") AND
           ("Document Type" <> "Document Type"::Quote)
        THEN
            ERROR(STRSUBSTNO(Text004, FORMAT("Limit Type"), "Table ID"));
    end;

    //[Scope('Internal')]
    procedure RenameAddApprovers(Template: Record "Approval Templates"; xTemplate: Record "Approval Templates")
    var
        AddApprovers: Record "Additional Approvers";
        RenamedAddApprovers: Record "Additional Approvers";
    begin
        AddApprovers.SETRANGE("Approval Code", xTemplate."Approval Code");
        AddApprovers.SETRANGE("Approval Type", xTemplate."Approval Type");
        AddApprovers.SETRANGE("Document Type", xTemplate."Document Type");
        AddApprovers.SETRANGE("Limit Type", xTemplate."Limit Type");
        IF AddApprovers.FIND('-') THEN
            REPEAT
                RenamedAddApprovers := AddApprovers;
                RenamedAddApprovers."Approval Code" := Template."Approval Code";
                RenamedAddApprovers."Approval Type" := Template."Approval Type";
                RenamedAddApprovers."Document Type" := Template."Document Type";
                RenamedAddApprovers."Limit Type" := Template."Limit Type";
                AddApprovers.DELETE;
                RenamedAddApprovers.INSERT;
            UNTIL AddApprovers.NEXT = 0;
    end;
}

