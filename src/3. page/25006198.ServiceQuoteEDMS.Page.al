page 25006198 "Service Quote EDMS"
{
    // 23.04.2015 EDMS P21
    //   Modified triggers:
    //     VIN - OnLookup
    //     Vehicle Registration No. - OnLookup
    // 
    // 16.03.2015 EDMS P21
    //   Modified triggers:
    //     OnAfterGetCurrRecord
    //     Vehicle Serial No. - OnValidate
    //   Modified Editable property for fields:
    //     "Make Code"
    //     "Model Code"
    //     "Model Version No."
    // 
    // 20.02.2015 EDMS P21
    //   Added field:
    //     "Model Version No."
    // 
    // 31.03.2014 Elva Baltic P18 MMG7.00
    //   Added fields
    //     ShortcutDimCode[3]..[8]
    //   Added Code to
    //     OnAfterGetRecord()
    // 
    // 24.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Fixed "Document Info" FactBox link
    // 
    // 24.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Action "Schedule" set VISIBLE=FALSE
    // 
    // 22.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   *"Deal Type" field moved to the general tab
    //   *Changed FactBox order
    //   *The following fields set Visible=FALSE:
    //    - Description
    //    - "Responsibility Center"
    //    - "No. of Archived Versions"
    //   *Importance property set to Standard for fields:
    //    - Order Date
    //    - Order Time
    //    - Phone No.
    //    - "Sell-to Contact No."
    //    - "Sell-to Contact"
    //   *Importance property set to Additional for fields:
    //    - Posting Date
    //    - Sell-to City
    //    *"Foreign Trade" & Advanced tabs set Visible=FALSE
    // 
    // 20.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * Added LVI captions
    // 
    // 19.02.2014 Elva Baltic P7 #R130 MMG7.00
    //   * Service Quote fore Body work report added
    // 
    // 12.08.2013 EDMS P8
    //   * REMOVED MILLISECONDS
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3

    Caption = 'Service Quote';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Print';
    RefreshOnActivate = true;
    SourceTable = Table25006145;
    SourceTableView = WHERE(Document Type=FILTER(Quote));

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
                    Enabled = SelltoCustomerNoEnable;
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
                    Visible = false;
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
                field("Vehicle Serial No.";"Vehicle Serial No.")
                {
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;    // 16.03.2015 EDMS P21
                    end;
                }
                field(VIN;VIN)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // 23.04.2015 EDMS P21 >>
                        OnLookupVIN;
                        CurrPage.UPDATE;
                        // 23.04.2015 EDMS P21 <<
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;   // 23.04.2015 EDMS P21
                    end;
                }
                field("Vehicle Registration No.";"Vehicle Registration No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // 23.04.2015 EDMS P21 >>
                        OnLookupVehicleRegistrationNo;
                        CurrPage.UPDATE;
                        // 23.04.2015 EDMS P21 <<
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;   // 23.04.2015 EDMS P21
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
                    Importance = Additional;
                }
                field("Order Date";"Order Date")
                {
                    Importance = Promoted;
                }
                field("Order Time";"Order Time")
                {
                }
                field("Work Status Code";"Work Status Code")
                {
                }
                field("Service Person";"Service Person")
                {
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field(Status;Status)
                {
                    Importance = Promoted;
                }
                field("Quote Applicable To Date";"Quote Applicable To Date")
                {
                    Importance = Additional;
                }
                field("Customer Price Group";"Customer Price Group")
                {
                }
                field("Amount Including VAT";"Amount Including VAT")
                {
                }
            }
            part(ServiceLines;25006199)
            {
                SubPageLink = Document No.=FIELD(No.);
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    Enabled = BilltoCustomerNoEnable;
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
                field("Payment Method Code";"Payment Method Code")
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
                field("<Posting Date 2>";"Posting Date")
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
                field("<No. of Archived Versions 2>";"No. of Archived Versions")
                {
                }
                field("Initiator Code";"Initiator Code")
                {
                }
                field("Location Code";"Location Code")
                {
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
            group("Service Address")
            {
                Caption = 'Service Address';
                field("Service Address Code";"Service Address Code")
                {
                }
                field("Service Address Name";"Service Address Name")
                {
                }
                field("Service Address";"Service Address")
                {
                }
                field("Service Address 2";"Service Address 2")
                {
                }
                field("Service Address Post Code";"Service Address Post Code")
                {
                }
                field("Service Address City";"Service Address City")
                {
                }
                field("Service Address Contact";"Service Address Contact")
                {
                }
            }
        }
        area(factboxes)
        {
            part(;25006253)
            {
                SubPageLink = Document Type=FIELD(Document Type),
                              No.=FIELD(No.);
                Visible = true;
            }
            part("Document Info";25006092)
            {
                Caption = 'Document Info';
                SubPageLink = Document Type=FIELD(Document Type),
                              No.=FIELD(No.);
            }
            part(;25006071)
            {
                SubPageLink = No.=FIELD(Sell-to Customer No.);
                Visible = false;
            }
            part(;25006074)
            {
                SubPageLink = No.=FIELD(Bill-to Customer No.);
                Visible = false;
            }
            part(;9084)
            {
                SubPageLink = No.=FIELD(Sell-to Customer No.);
                Visible = false;
            }
            part(;25006241)
            {
                Provider = ServiceLines;
                SubPageLink = Document Type=FIELD(Document Type),
                              Document No.=FIELD(Document No.),
                              Line No.=FIELD(Line No.);
                Visible = true;
            }
            part(;9089)
            {
                Provider = ServiceLines;
                SubPageLink = No.=FIELD(No.);
                Visible = false;
            }
            part(;9092)
            {
                SubPageLink = Table ID=CONST(36),
                              Document Type=FIELD(Document Type),
                              Document No.=FIELD(No.),
                              Status=CONST(Open);
                Visible = false;
            }
            part(;9108)
            {
                Provider = ServiceLines;
                SubPageLink = No.=FIELD(No.);
                Visible = false;
            }
            part(;9109)
            {
                Provider = ServiceLines;
                SubPageLink = No.=FIELD(No.);
                Visible = false;
            }
            part(;25006073)
            {
                SubPageLink = No.=FIELD(Bill-to Customer No.);
                Visible = false;
            }
            part("Vehicle Pictures";25006047)
            {
                Caption = 'Vehicle Pictures';
                SubPageLink = Source Type=CONST(25006005),
                              Source Subtype=CONST(0),
                              Source ID=FIELD(Vehicle Serial No.),
                              Source Ref. No.=CONST(0);
                SubPageView = SORTING(Source Type,Source Subtype,Source ID,Source Ref. No.,No.);
            }
            systempart(;Links)
            {
                Visible = false;
            }
            systempart(;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action59>")
            {
                Caption = 'Q&uote';
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
                action("<Action1102601029>")
                {
                    Caption = 'Customer Card';
                    Image = CustomerCode;
                    RunObject = Page 21;
                                    RunPageLink = No.=FIELD(Sell-to Customer No.);
                    ShortCutKey = 'Shift+F7';
                }
                action("<Action1102601030>")
                {
                    Caption = 'C&ontact Card';
                    Image = ContactPerson;
                    RunObject = Page 5052;
                                    RunPageLink = No.=FIELD(Sell-to Contact No.);
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
                                    RunPageLink = Type=CONST(Service Quote),
                                  No.=FIELD(No.);
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
                action("<Action78>")
                {
                    Caption = 'A&pprovals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Service Header EDMS","Document Type","No.");
                        ApprovalEntries.RUN;
                    end;
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
            group(Vehicle)
            {
                Caption = 'Vehicle';
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
            group(Release)
            {
                Caption = 'Release';
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReleaseServiceDoc: Codeunit "25006119";
                    begin
                        ReleaseServiceDoc.PerformManualReopen(Rec);
                    end;
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseServiceDoc: Codeunit "25006119";
                    begin
                        ReleaseServiceDoc.PerformManualRelease(Rec);
                    end;
                }
            }
            group(Print)
            {
                Caption = 'Print';
                action("<Action169>")
                {
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ServLine: Record "25006146";
                        DocMgt: Codeunit "25006000";
                        DocReport: Record "25006011";
                        ServHeaders: Record "25006145";
                    begin
                        /*
                        //DocPrint.PrintSalesHeader(Rec);
                        ServLine.RESET;
                        DocMgt.PrintCurrentDoc(3, 3, 0, DocReport);
                        DocMgt.SelectServDocReport(DocReport, Rec, ServLine,FALSE);
                        *///AGNI UPG 2009
                        
                        CurrPage.SETSELECTIONFILTER(ServHeaders);
                        REPORT.RUNMODAL(33020245,TRUE,FALSE,ServHeaders);

                    end;
                }
                action(Email)
                {
                    Caption = 'Email';
                    Image = SendEmailPDF;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServLine: Record "25006146";
                        DocMgt: Codeunit "25006000";
                        DocReport: Record "25006011";
                    begin
                        ServLine.RESET;
                        DocMgt.PrintCurrentDoc(3, 3, 0, DocReport);
                        DocMgt.SelectServDocReport(DocReport, Rec, ServLine,TRUE);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("<Action67>")
                {
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                    end;
                }
                action("Copy Document")
                {
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

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
                action("Insert Service Package")
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
                        SendSMS.SetDocumentType(1);
                        SendSMS.SetSalespersonCode(SalespersonCode);
                        SendSMS.SetContactNo(Rec."Sell-to Contact No.");
                        SendSMS.SetPhoneNo(Rec."Mobile Phone No.");
                        SendSMS.RUN;
                    end;
                }
                action("Copy Document to Sales Quote")
                {
                    Caption = 'Copy Document to Sales Quote';
                    Image = Copy;

                    trigger OnAction()
                    var
                        SalesQuote: Record "36";
                    begin
                        CopyDocMgt.CopyServQuoteToSalesQuote(SalesQuote,"No.");
                    end;
                }
            }
            group(Create)
            {
                Caption = 'Create';
                action("<Action168>")
                {
                    Caption = 'Make &Order';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "38";
                    begin
                        //IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN
                          CODEUNIT.RUN(CODEUNIT::"Serv-Quote to Order (Y/N) EDMS",Rec);
                    end;
                }
                action("<Action1102601015>")
                {
                    Caption = 'C&reate Contact';
                    Image = NewCustomer;

                    trigger OnAction()
                    begin
                        IF CheckContactCreated(FALSE) THEN
                          CurrPage.UPDATE(TRUE);
                    end;
                }
                action("<Action1102701015>")
                {
                    Caption = 'C&reate Customer';
                    Image = NewCustomer;

                    trigger OnAction()
                    begin
                        IF CheckCustomerCreated(FALSE) THEN
                          CurrPage.UPDATE(TRUE);
                    end;
                }
                action("<Action1102801015>")
                {
                    Caption = 'C&reate Vehicle';
                    Image = New;

                    trigger OnAction()
                    begin
                        IF CheckVehicleCreated(FALSE) THEN
                          CurrPage.UPDATE(TRUE);
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
                    Visible = false;

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "25006358";
                    begin
                        //ServiceSchedule.SetServiceHeader(Rec);
                        //ServiceSchedule.RUN;
                    end;
                }
            }
            group(Request)
            {
                Caption = 'Request';
                action("<Action250>")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.SendSalesApprovalRequest(Rec) THEN;
                    end;
                }
                action("<Action251>")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.CancelSalesApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        MakeModelEditable := "Vehicle Serial No." = '';        // 16.03.2015 EDMS P21
    end;

    trigger OnAfterGetRecord()
    begin
        Resources := ServiceScheduleMgt.GetRelatedResources("Document Type", "No.", ServiceLine.Type::Labor, 0, 0);
        ActivateFields;
        Resources := GetResourceTextFieldValue;
        //EVALUATE("Order Time", COPYSTR(FORMAT("Order Time", 0, '<Hours24,2>:<Minutes,2>:<Seconds,2>'), 1, 8));  //12.08.2013 EDMS P8
        ShowShortcutDimCode(ShortcutDimCode); // 31.03.2014 Elva Baltic P18 MMG7.00
        CALCFIELDS("Schedule Start Date Time", "Schedule End Date Time");
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        LostSaleMgt.OnServHeaderDelete(Rec);
        CurrPage.SAVERECORD;
        EXIT(ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        BilltoCustomerNoEnable := TRUE;
        SelltoCustomerNoEnable := TRUE;
        SelltoCustomerTemplateCodeEnab := TRUE;
        BilltoCustomerTemplateCodeEnab := TRUE;
        IsVFRun1Visible := IsVFActive(FIELDNO(Kilometrage));
        //IsVFRun2Visible := IsVFActive(FIELDNO("Variable Field Run 2"));
        //IsVFRun3Visible := IsVFActive(FIELDNO("Variable Field Run 3"));
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CheckCreditMaxBeforeInsert;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        
        /*
        "Responsibility Center" := UserMgt.GetSalesFilter;
        *///AGNI UPG 2009
        
        IF UserMgt.DefaultResponsibility THEN
          "Responsibility Center" := UserMgt.GetSalesFilter()
        ELSE
          "Accountability Center" := UserMgt.GetSalesFilter();
        
        
        CLEAR(Resources);
        SetResourceTextFieldValue(Resources);

    end;

    trigger OnOpenPage()
    begin
        /*
        IF UserMgt.GetServiceFilterEDMS <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetServiceFilterEDMS);
          FILTERGROUP(0);
        END;
        *///AGNI 2009 UPG
        
        IF UserMgt.GetSalesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          IF UserMgt.DefaultResponsibility THEN
            SETRANGE("Responsibility Center",UserMgt.GetSalesFilter())
          ELSE
            SETRANGE("Accountability Center",UserMgt.GetSalesFilter());
          FILTERGROUP(0);
        END;
        
        
        SETRANGE("Date Filter",0D,WORKDATE - 1);
        ActivateFields;
        
        SetDocNoVisible;

    end;

    var
        Text000: Label 'Unable to execute this function while in view only mode.';
        CopyServDoc: Report "25006135";
                         DocPrint: Codeunit "229";
                         ArchiveManagement: Codeunit "5063";
                         UserMgt: Codeunit "5700";
                         ApprovalEntries: Page "658";
                         ChangeExchangeRate: Page "511";
                         LostSaleMgt: Codeunit "25006504";
    [InDataSet]

    BilltoCustomerTemplateCodeEnab: Boolean;
        [InDataSet]
        SelltoCustomerTemplateCodeEnab: Boolean;
        [InDataSet]
        SelltoCustomerNoEnable: Boolean;
        [InDataSet]
        BilltoCustomerNoEnable: Boolean;
        ServiceScheduleMgt: Codeunit "25006201";
        [InDataSet]
        Resources: Text[250];
        ServiceLine: Record "25006146";
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        ShortcutDimCode: array [8] of Code[20];
        DocNoVisible: Boolean;
        MakeModelEditable: Boolean;
        DateTimeMgt: Codeunit "25006012";
        CopyDocMgt: Codeunit "6620";

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

    local procedure SelltoCustomerTemplateCodeOnAf()
    begin
        ActivateFields;
        CurrPage.UPDATE;
    end;

    local procedure BilltoCustomerTemplateCodeOnAf()
    begin
        ActivateFields;
        CurrPage.UPDATE;
    end;

    [Scope('Internal')]
    procedure ActivateFields()
    begin
        BilltoCustomerTemplateCodeEnab := "Bill-to Customer No." = '';
        SelltoCustomerTemplateCodeEnab := "Sell-to Customer No." = '';
        SelltoCustomerNoEnable := "Sell-to Customer Template Code" = '';
        BilltoCustomerNoEnable := "Bill-to Customer Template Code" = '';
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit "1400";
        DocType: Option Quote,"Order","Return Order";
    begin
        DocNoVisible := DocumentNoVisibility.ServiceDocumentNoIsVisible(DocType::Quote,"No.");
    end;
}

