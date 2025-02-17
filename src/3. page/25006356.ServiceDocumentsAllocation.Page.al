page 25006356 "Service Documents - Allocation"
{
    Caption = 'Service Documents - Allocation';
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table25006145;
    SourceTableView = WHERE(Document Type=FILTER(Order),
                            Job Closed=FILTER(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type";"Document Type")
                {
                }
                field("No.";"No.")
                {
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                }
                field(VIN;VIN)
                {
                }
                field("Make Code";"Make Code")
                {
                }
                field("Model Code";"Model Code")
                {
                }
                field("Vehicle Registration No.";"Vehicle Registration No.")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1101904012>")
            {
                Caption = 'Create Service Quote';
                Image = Quote;
                Promoted = true;

                trigger OnAction()
                begin
                    DocumentNo := ServiceScheduleMgt.CreateNewServiceDocument(DocumentType::Quote);
                    SETRANGE("Document Type", "Document Type"::Quote);
                    SETRANGE("No.", DocumentNo);
                    IF FINDFIRST THEN;
                    SETRANGE("Document Type");
                    SETRANGE("No.");
                end;
            }
            action("<Action1101904021>")
            {
                Caption = 'Create Service Order';
                Image = NewOrder;
                Promoted = true;

                trigger OnAction()
                begin
                    DocumentNo := ServiceScheduleMgt.CreateNewServiceDocument(DocumentType::Order);
                    SETRANGE("Document Type", "Document Type"::Order);
                    SETRANGE("No.", DocumentNo);
                    IF FINDFIRST THEN;
                    SETRANGE("Document Type");
                    SETRANGE("No.");
                end;
            }
        }
        area(processing)
        {
            action("<Action1101904013>")
            {
                Caption = '&Edit';
                Image = Edit;
                Promoted = true;
                ShortCutKey = 'Shift+Ctrl+E';

                trigger OnAction()
                begin
                    IF "Document Type" = "Document Type"::Quote THEN
                      PAGE.RUN(PAGE::"Service Quote EDMS", Rec)
                    ELSE
                      PAGE.RUN(PAGE::"Service Order EDMS", Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "91";
        ResponsiblityCenter: Code[20];
        Location: Code[10];
    begin
        IF SingleInstanceMgt.GetServiceHeader(ServiceHeader) THEN BEGIN
          "Document Type" := ServiceHeader."Document Type";
          "No." := ServiceHeader."No.";
        END;
        //SETRANGE("Document Type",ServiceHeader."Document Type"); //!!
        FilterOnRecord;
    end;

    var
        SingleInstanceMgt: Codeunit "25006001";
        ServiceHeader: Record "25006145";
        DocumentNo: Code[20];
        DocumentType: Option Quote,"Order","Return Order";
        ServiceScheduleMgt: Codeunit "25006201";

    [Scope('Internal')]
    procedure SetDocumentType(DocumentTypeForFilter: Option)
    begin
        DocumentType := DocumentTypeForFilter;
    end;

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetServiceFilterEDMS();
        IF RespCenterFilter <> '' THEN BEGIN
          FILTERGROUP(2);
           IF UserMgt.DefaultResponsibility THEN
              SETRANGE("Responsibility Center",RespCenterFilter)
          ELSE
              SETRANGE("Accountability Center",RespCenterFilter);
          FILTERGROUP(0);
        END;
    end;
}

