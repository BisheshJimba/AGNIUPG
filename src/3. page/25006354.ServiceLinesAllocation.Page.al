page 25006354 "Service Lines - Allocation"
{
    Caption = 'Service Lines - Allocation';
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table25006146;
    SourceTableView = SORTING(Document Type, Document No., Line No.)
                      ORDER(Ascending)
                      WHERE(Document Type=FILTER(Quote|Order),
                            Type=CONST(Labor));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type";"Document Type")
                {
                }
                field("Document No.";"Document No.")
                {
                }
                field(Type;Type)
                {
                }
                field("No.";"No.")
                {
                }
                field(Description;Description)
                {
                }
                field("Description 2";"Description 2")
                {
                    Visible = false;
                }
                field(Resources;Resources)
                {
                    Caption = 'Resources';
                    Enabled = false;
                }
                field(Quantity;Quantity)
                {
                }
                field("Standard Time";"Standard Time")
                {
                    Visible = false;
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    Visible = false;
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    Visible = false;
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    Visible = false;
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
                field(VIN;VIN)
                {
                    Visible = false;
                }
                label("Resource No")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Create Service Quote")
            {
                Caption = 'Create Service Quote';
                Image = Quote;
                Promoted = true;

                trigger OnAction()
                begin
                    DocumentNo := ServiceScheduleMgt.CreateNewServiceDocument(DocumentType::Quote);
                    SETRANGE("Document Type", "Document Type"::Quote);
                    SETRANGE("Document No.", DocumentNo);
                    IF FINDFIRST THEN;
                    SETRANGE("Document Type");
                    SETRANGE("Document No.");
                end;
            }
            action("Create Service Order")
            {
                Caption = 'Create Service Order';
                Image = NewOrder;
                Promoted = true;

                trigger OnAction()
                begin
                    DocumentNo := ServiceScheduleMgt.CreateNewServiceDocument(DocumentType::Order);
                    SETRANGE("Document Type", "Document Type"::Order);
                    SETRANGE("Document No.", DocumentNo);
                    IF FINDFIRST THEN;
                    SETRANGE("Document Type");
                    SETRANGE("Document No.");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Resources := ServiceScheduleMgt.GetRelatedResources("Document Type", "Document No.", Type, "Line No.", 0);
    end;

    trigger OnOpenPage()
    begin
        /*//Agni UPG 2009
        FILTERGROUP(2);
        SETRANGE(Type,Type::Labor);
        FILTERGROUP(0);
        */
        
        FilterOnRecord;
        IF SingleInstanceMgt.GetServiceHeader(ServiceHeader) THEN BEGIN
          SETRANGE("Document Type",ServiceHeader."Document Type");
          SETRANGE("Document No.",ServiceHeader."No.");
          IF FINDFIRST THEN;
          SETRANGE("Document Type");
          SETRANGE("Document No.");
        END;
        //SETRANGE("Document Type","Document Type"::Order); //!!
        //SETRANGE("Document Type",ServiceHeader."Document Type"); //!!

    end;

    var
        SingleInstanceMgt: Codeunit "25006001";
        ServiceHeader: Record "25006145";
        [InDataSet]
        Resources: Text[250];
        ServiceScheduleMgt: Codeunit "25006201";
        DocumentNo: Code[20];
        DocumentType: Option Quote,"Order","Return Order";

    [Scope('Internal')]
    procedure SetSelectionFilter1(var ServLine: Record "25006146")
    begin
        CurrPage.SETSELECTIONFILTER(ServLine);
    end;

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

