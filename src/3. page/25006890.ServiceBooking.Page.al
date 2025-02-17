page 25006890 "Service Booking"
{
    Caption = 'Service Booking';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Print,Transfer';
    RefreshOnActivate = true;
    SourceTable = Table25006145;
    SourceTableView = WHERE(Document Type=FILTER(Booking));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    Importance = Promoted;
                    Visible = DocNoVisible;

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                          CurrPage.UPDATE;
                    end;
                }
                field("Deal Type";"Deal Type")
                {
                }
                field(Description;Description)
                {
                    Visible = false;
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                }
                field("Sell-to Address";"Sell-to Address")
                {
                    Importance = Additional;
                }
                field("Sell-to Address 2";"Sell-to Address 2")
                {
                    Importance = Additional;
                }
                field("Sell-to Post Code";"Sell-to Post Code")
                {
                    Importance = Additional;
                }
                field("Sell-to City";"Sell-to City")
                {
                    Importance = Additional;
                }
                field("Sell-to Contact No.";"Sell-to Contact No.")
                {
                    Importance = Standard;
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    Importance = Standard;
                }
                field("Phone No.";"Phone No.")
                {
                    Importance = Standard;
                }
                field("Mobile Phone No.";"Mobile Phone No.")
                {
                }
                field("No. of Archived Versions";"No. of Archived Versions")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("Planned Service Date";"Planned Service Date")
                {
                    Visible = false;
                }
                field("Vehicle Serial No.";"Vehicle Serial No.")
                {
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field(VIN;VIN)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // 23.04.2015 EDMS P21 >>
                        OnLookupVIN;
                        SelltoCustomerNoOnAfterValidat;
                        // 23.04.2015 EDMS P21 <<
                    end;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Vehicle Registration No.";"Vehicle Registration No.")
                {
                    Importance = Promoted;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        OnLookupVehicleRegistrationNo;
                        SelltoCustomerNoOnAfterValidat;
                    end;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Make Code";"Make Code")
                {
                    Editable = MakeModelEditable;
                }
                field("Model Code";"Model Code")
                {
                    Editable = MakeModelEditable;
                }
                field(Kilometrage;Kilometrage)
                {
                    Visible = IsVFRun1Visible;
                }
                field("Posting Date";"Posting Date")
                {
                    Importance = Standard;
                }
                field("Order Date";"Order Date")
                {
                    Importance = Standard;
                }
                field("Order Time";"Order Time")
                {
                    Importance = Standard;
                }
                field("Work Status Code";"Work Status Code")
                {
                }
                field("Service Person";"Service Person")
                {
                }
                field("Payment Method Code";"Payment Method Code")
                {
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("Contract No.";"Contract No.")
                {
                }
                field("Quote No.";"Quote No.")
                {
                    Editable = false;
                    Importance = Additional;
                }
                field(Status;Status)
                {
                    Importance = Promoted;
                }
                field("TCard Container Entry No.";"TCard Container Entry No.")
                {
                }
                field("Booking Resource No.";"Booking Resource No.")
                {
                }
            }
            part(ServiceLines;25006891)
            {
                SubPageLink = Document No.=FIELD(No.);
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No.";"Bill-to Contact No.")
                {
                    Importance = Additional;
                }
                field("Bill-to Name";"Bill-to Name")
                {
                }
                field("Bill-to Address";"Bill-to Address")
                {
                    Importance = Additional;
                }
                field("Bill-to Address 2";"Bill-to Address 2")
                {
                    Importance = Additional;
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    Importance = Additional;
                }
                field("Bill-to City";"Bill-to City")
                {
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    Importance = Additional;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field(ShortcutDimCode[3];ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(3,ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode[4];ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(4,ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode[5];ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(5,ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode[6];ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(6,ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode[7];ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(7,ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode[8];ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(8,ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    Importance = Promoted;
                }
                field("Due Date";"Due Date")
                {
                    Importance = Promoted;
                }
                field("Payment Discount %";"Payment Discount %")
                {
                }
                field("Customer Price Group";"Customer Price Group")
                {
                }
                field("Prices Including VAT";"Prices Including VAT")
                {

                    trigger OnValidate()
                    begin
                        PricesIncludingVATOnAfterValid;
                    end;
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                }
                field("External Document No.";"External Document No.")
                {
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                Visible = false;
                field("Currency Code";"Currency Code")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        CLEAR(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                          VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
                          CurrPage.UPDATE;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeOnAfterValidate;
                    end;
                }
                field("EU 3-Party Trade";"EU 3-Party Trade")
                {
                }
                field("Transaction Type";"Transaction Type")
                {
                }
                field("Transaction Specification";"Transaction Specification")
                {
                }
                field("Transport Method";"Transport Method")
                {
                }
                field("Exit Point";"Exit Point")
                {
                }
                field(Area;Area)
                {
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field("<Posting Date2>";"Posting Date")
                {
                }
                field("Document Date";"Document Date")
                {
                }
                field("Requested Starting Date";"Requested Starting Date")
                {
                }
                field("Requested Starting Time";"Requested Starting Time")
                {
                }
                field("Requested Finishing Date";"Requested Finishing Date")
                {
                }
                field("Requested Finishing Time";"Requested Finishing Time")
                {
                }
                field("Arrival Date";"Arrival Date")
                {
                }
                field("Arrival Time";"Arrival Time")
                {
                }
                field("Finished Quantity (Hours)";"Finished Quantity (Hours)")
                {
                }
                field("Remaining Quantity (Hours)";"Remaining Quantity (Hours)")
                {
                }
                field("Planning Policy";"Planning Policy")
                {
                }
                field("<No. of Archived Versions2>";"No. of Archived Versions")
                {
                }
                field("Initiator Code";"Initiator Code")
                {
                }
                field("Location Code";"Location Code")
                {
                    Importance = Promoted;
                }
                field("Vehicle Accounting Cycle No.";"Vehicle Accounting Cycle No.")
                {
                }
                field("Vehicle Status Code";"Vehicle Status Code")
                {
                }
                field("Vehicle Item Charge No.";"Vehicle Item Charge No.")
                {
                }
                field("Warranty Claim No.";"Warranty Claim No.")
                {
                }
                field(Resources;Resources)
                {
                    Caption = 'Resources';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SAVERECORD;
                        RelatedResourcesList(Resources);
                        Resources := GetResourceTextFieldValue;
                    end;

                    trigger OnValidate()
                    begin
                        SetResourceTextFieldValue(Resources);
                        Resources := GetResourceTextFieldValue;
                    end;
                }
                field("Model Version No.";"Model Version No.")
                {
                    Editable = MakeModelEditable;
                }
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                Visible = false;
                field("Prepayment %";"Prepayment %")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        Prepayment37OnAfterValidate;
                    end;
                }
                field("Compress Prepayment";"Compress Prepayment")
                {
                }
                field("Prepmt. Payment Terms Code";"Prepmt. Payment Terms Code")
                {
                }
                field("Prepayment Due Date";"Prepayment Due Date")
                {
                    Importance = Promoted;
                }
                field("Prepmt. Payment Discount %";"Prepmt. Payment Discount %")
                {
                }
                field("Prepmt. Pmt. Discount Date";"Prepmt. Pmt. Discount Date")
                {
                }
            }
            group(Advanced)
            {
                Caption = 'Advanced';
                Visible = false;
                field(DateTimeMgt.Datetime2Date("Schedule Start Date Time");DateTimeMgt.Datetime2Date("Schedule Start Date Time"))
                {
                    Caption = 'Schedule Start Date';
                    Editable = false;
                }
                field(DateTimeMgt.Datetime2Time("Schedule Start Date Time");DateTimeMgt.Datetime2Time("Schedule Start Date Time"))
                {
                    Caption = 'Schedule Start Time';
                    Editable = false;
                }
                field(DateTimeMgt.Datetime2Date("Schedule End Date Time");DateTimeMgt.Datetime2Date("Schedule End Date Time"))
                {
                    Caption = 'Schedule End Date';
                    Editable = false;
                }
                field(DateTimeMgt.Datetime2Time("Schedule End Date Time");DateTimeMgt.Datetime2Time("Schedule End Date Time"))
                {
                    Caption = 'Schedule End Time';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("O&rder")
            {
                Caption = 'O&rder';
                action("<Action61>")
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        //CalcInvDiscForHeader;
                        COMMIT;
                        PAGE.RUNMODAL(PAGE::"Service Order Statistics EDMS",Rec);
                    end;
                }
                action("<Action62>")
                {
                    Caption = 'Customer Card';
                    Image = EditLines;
                    RunObject = Page 21;
                                    RunPageLink = No.=FIELD(Sell-to Customer No.);
                    ShortCutKey = 'Shift+F7';
                }
                action("<Action1101904005>")
                {
                    Caption = 'V&ehicle Card';
                    Image = EditLines;
                    RunObject = Page 25006033;
                                    RunPageLink = Serial No.=FIELD(Vehicle Serial No.);
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=CONST(Service Order),
                                  No.=FIELD(No.);
                }
                action(VehicleComment)
                {
                    Caption = 'Vehicle Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=CONST(Vehicle),
                                  No.=FIELD(Vehicle Serial No.);
                }
                action(BillToCustomerComment)
                {
                    Caption = 'Bill-To Customer Comments';
                    Image = ViewComments;
                    RunObject = Page 124;
                                    RunPageLink = Table Name=CONST(Customer),
                                  No.=FIELD(Bill-to Customer No.);
                }
                action(SelllToCustomerComment)
                {
                    Caption = 'Sell-To Customer Comments';
                    Image = ViewComments;
                    RunObject = Page 124;
                                    RunPageLink = Table Name=CONST(Customer),
                                  No.=FIELD(Sell-to Customer No.);
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                        CurrPage.SAVERECORD;
                    end;
                }
                action(VehicleQuotes)
                {
                    Caption = 'Vehicle Quotes';
                    Image = Quote;
                    RunObject = Page 25006254;
                                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.);
                }
            }
            group(Schedule)
            {
                Caption = 'Schedule';
                action("<Action1101904014>")
                {
                    Caption = 'Schedule Allocation Entries';
                    Image = EntriesList;

                    trigger OnAction()
                    var
                        ServLaborAllocation: Record "25006271";
                        ScheduleMgt: Codeunit "25006201";
                    begin
                        ServLaborAllocation.RESET;
                        ScheduleMgt.FindServAllocationEntries(ServLaborAllocation, "Document Type", "No.");
                        PAGE.RUNMODAL(PAGE::"Serv. Labor Allocation Entries", ServLaborAllocation);
                    end;
                }
                action("<Action1101904015>")
                {
                    Caption = 'Schedule Application Entries';
                    Image = EntriesList;

                    trigger OnAction()
                    var
                        ServLaborAllocAplication: Record "25006277";
                        ScheduleMgt: Codeunit "25006201";
                    begin
                        ServLaborAllocAplication.RESET;
                        ScheduleMgt.FindServAllocAplicationEntries(ServLaborAllocAplication, "Document Type", "No.");
                        PAGE.RUNMODAL(PAGE::"Serv. Labor Alloc. Application", ServLaborAllocAplication);
                    end;
                }
            }
            group("&Vehicle")
            {
                Caption = '&Vehicle';
                action("Process Checklists")
                {
                    Caption = 'Process Checklists';
                    Image = CheckList;
                    RunObject = Page 25006010;
                                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.);
                }
                action(Pictures)
                {
                    Caption = 'Pictures';
                    Image = Picture;
                    RunObject = Page 25006059;
                                    RunPageLink = Source Type=CONST(25006005),
                                  Source Subtype=CONST(0),
                                  Source ID=FIELD(Vehicle Serial No.),
                                  Source Ref. No.=CONST(0);
                    RunPageMode = View;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Copy Document")
                {
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;

                    trigger OnAction()
                    begin
                        CopyServDoc.SetServOrdHeader(Rec);
                        CopyServDoc.RUNMODAL;
                        CLEAR(CopyServDoc);
                    end;
                }
                action("Archi&ve Document")
                {
                    Caption = 'Archi&ve Document';
                    Image = Archive;

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchiveServiceDocument(Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action(CreateQuote)
                {
                    Caption = 'Create Quote';
                    Image = Quote;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ServiceSplittingLine.LOCKTABLE;
                        ServiceSplittingLine.RESET;
                        ServiceSplittingLine.DeleteDocQuote("Document Type", "No.");
                        ServiceSplittingLine.CreateLinesForQuote(Rec);

                        ServiceSplittingLine.RESET;
                        ServiceSplittingLine.SETRANGE(Line, TRUE);
                        ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
                        ServiceSplittingLine.SETRANGE("Document No.", "No.");
                        ServiceSplittingLine.SETRANGE("Temp. Document No.", 0);
                        PAGE.RUN(PAGE::"Create Service Quote", ServiceSplittingLine);
                    end;
                }
                action("Send SMS")
                {
                    Caption = 'Send SMS';
                    Image = SendTo;

                    trigger OnAction()
                    var
                        SendSMS: Page "25006404";
                                     UserSetup: Record "91";
                                     SalespersonCode: Code[10];
                    begin
                        UserSetup.GET(USERID);
                        IF UserSetup."Salespers./Purch. Code" <> '' THEN
                          SalespersonCode := UserSetup."Salespers./Purch. Code"
                        ELSE
                          SalespersonCode := Rec."Service Person";

                        SendSMS.SetDocumentNo(Rec."No.");
                        SendSMS.SetDocumentType(2);
                        SendSMS.SetSalespersonCode(SalespersonCode);
                        SendSMS.SetContactNo(Rec."Sell-to Contact No.");
                        SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                        SendSMS.RUN;
                    end;
                }
            }
            group(Plan)
            {
                Caption = 'Plan';
                action("<Action1101904031>")
                {
                    Caption = 'Schedule';
                    Image = Allocations;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006358;
                                    RunPageLink = Document Type=FIELD(Document Type),
                                  No.=FIELD(No.);
                    RunPageOnRec = true;

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "25006358";
                    begin
                        //ServiceSchedule.SetServiceHeader(Rec);
                        //ServiceSchedule.RUN;
                    end;
                }
            }
            group("Service Packages")
            {
                Caption = 'Service Packages';
                action(InsertServicePackage)
                {
                    Caption = 'Insert Service Package';
                    Image = CopyFromTask;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        InsertServPackage
                    end;
                }
                action(InsertPackRecall)
                {
                    Caption = 'Insert Recall Compaign Package';
                    Image = CopyFromTask;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        InsertServPackageRecall;
                    end;
                }
                action("Insert Service Plan Package")
                {
                    Caption = 'Insert Service Plan Package';
                    Image = CopyFromTask;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        InsertServPackagePlaned;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        MakeModelEditable := "Vehicle Serial No." = '';        // 20.02.2015 EDMS P21
    end;

    trigger OnAfterGetRecord()
    begin
        Resources := GetResourceTextFieldValue;
        CALCFIELDS("Schedule Start Date Time", "Schedule End Date Time");
        //EVALUATE("Order Time", COPYSTR(FORMAT("Order Time", 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>'), 1, 8));  //12.08.2013 EDMS P8
        //MESSAGE('IsVFRun1Visible='+FORMAT(IsVFRun1Visible));

        ShowShortcutDimCode(ShortcutDimCode); // 31.03.2014 Elva Baltic P18 MMG7.00
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        LostSaleMgt.OnServHeaderDelete(Rec);

        // 28.03.2014 Elva Baltic P21 >>
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", "Document Type");
        ServiceLine.SETRANGE("Document No.", "No.");
        IF ServiceLine.FINDFIRST THEN
          REPEAT
            ServiceLine.DeleteAssignedTransfLine;
          UNTIL ServiceLine.NEXT = 0;
        // 28.03.2014 Elva Baltic P21 <<

        CurrPage.SAVERECORD;
        EXIT(ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        IsVFRun1Visible := IsVFActive(FIELDNO(Kilometrage));
        //IsVFRun2Visible := IsVFActive(FIELDNO("Variable Field Run 2")); <<Bishesh Jimba 2/4/25
        //IsVFRun3Visible := IsVFActive(FIELDNO("Variable Field Run 3"));   Bishesh Jimba>>
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CheckCreditMaxBeforeInsert;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Responsibility Center" := UserMgt.GetSalesFilter;
        CLEAR(Resources);
        SetResourceTextFieldValue(Resources);
    end;

    trigger OnOpenPage()
    begin
        IF UserMgt.GetServiceFilterEDMS <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetServiceFilterEDMS);
          FILTERGROUP(0);
        END;

        SETRANGE("Date Filter",0D,WORKDATE - 1);

        SetDocNoVisible;
    end;

    var
        Text000: Label 'Unable to execute this function while in view only mode.';
        ServPostYNPrepmt: Codeunit "25006607";
        CopyServDoc: Report "25006135";
                         ReportPrint: Codeunit "228";
                         ArchiveManagement: Codeunit "5063";
                         UserMgt: Codeunit "5700";
                         ApprovalEntries: Page "658";
                         ChangeExchangeRate: Page "511";
                         Text001: Label 'There are non posted Prepayment Amounts on %1 %2.';
        Text002: Label 'There are unpaid Prepayment Invoices related to %1 %2.';
        Text101: Label 'Transfer Order is successfully created.';
        Text102: Label 'System changed values in Service Line field Planned Service Date.';
        ServInfoPaneMgt: Codeunit "25006104";
        LostSaleMgt: Codeunit "25006504";
        ServiceSplittingLine: Record "25006128";
        [InDataSet]
        Resources: Text[250];
        ServiceLine: Record "25006146";
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        DateTimeMgt: Codeunit "25006012";
        Err001: Label 'Order already has the invoice.';
        Text103: Label 'Item Unit Price is successfully updated!';
        Text104: Label 'Please update Item Unit Price!';
        ShortcutDimCode: array [8] of Code[20];
        Text105: Label 'Posting Date is not Today! Do you want to continue?';
        DocNoVisible: Boolean;
        [InDataSet]
        MakeModelEditable: Boolean;
        SingleInstanceMgt: Codeunit "25006001";

    [Scope('Internal')]
    procedure UpdateAllowed(): Boolean
    begin
        IF CurrPage.EDITABLE = FALSE THEN
          ERROR(Text000);
        EXIT(TRUE);
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.ServiceLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        CurrPage.UPDATE;
        //CurrPage."Service Document FactBox EDMS".PAGE.UpdateForm(TRUE);
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.ServiceLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.ServiceLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.ServiceLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure PricesIncludingVATOnAfterValid()
    begin
        CurrPage.UPDATE;
    end;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        CurrPage.ServiceLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure Prepayment37OnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    [Scope('Internal')]
    procedure UpdateItemUnitPrice()
    var
        ServiceLineEDMS: Record "25006146";
    begin
        ServiceLineEDMS.RESET;
        ServiceLineEDMS.SETRANGE("Document Type", "Document Type");
        ServiceLineEDMS.SETRANGE("Document No.", "No.");
        ServiceLineEDMS.SETRANGE(Type, ServiceLineEDMS.Type::Item);
        IF ServiceLineEDMS.FIND('-') THEN
          REPEAT
            ServiceLineEDMS.VALIDATE(Quantity);
            ServiceLineEDMS.MODIFY;
          UNTIL ServiceLineEDMS.NEXT = 0;
        MODIFY;
        MESSAGE(Text103);
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit "1400";
        DocType: Option Quote,"Order","Return Order",Booking;
    begin
        DocNoVisible := DocumentNoVisibility.ServiceDocumentNoIsVisible(DocType::Booking,"No.");
    end;
}

