page 25006183 "Service Order EDMS"
{
    // 30.08.2016 EB.P7 WSH16
    //   Field added:
    //     25007405"Finished Travel Qty (Hours)"
    // 
    // 22.10.2015 NAV2016 Merge
    //   Approvals removed
    // 12.08.2015 EB.P30 P393.T0056 EAMS1.00
    //   Changed property 'Editable' to FALSE for field "Quote No."
    // 
    // 23.04.2015 EDMS P21
    //   Modified triggers:
    //     VIN - OnLookup
    // 
    // 26.02.2015 EDMS P21
    //   Modified trigger:
    //     <Action25> - OnAction
    //   Added field:
    //     "Quote No."
    // 
    // 20.02.2015 EDMS P21
    //   Added field:
    //     "Model Version No."
    //   Modified trigger:
    //     OnAfterGetCurrRecord
    //   Modified Editable property for fields:
    //     "Make Code"
    //     "Model Code"
    // 
    // 10.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Set Visible TRUE for page action:
    //     Create Quote
    //   Added page action:
    //     Vehicle Quotes
    // 
    // 06.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added page action:
    //     Create Quote
    //   Added code to trigger:
    //     <Action1101904040> - OnAction()     (Split Document)
    // 
    // 16.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     "Contract No."
    // 
    // 16.04.2014 Elva Baltic P7 # MMG7.00
    //   * Field "Shipping Agent Code" added
    // 
    // 08.04.2014 Elva Baltic P7 #RX MMG7.00
    //   * Field "Bill-to Bank Acc. No." added
    // 
    // 04.04.2014 Elva Baltic P15 # MMG7.00
    //   * Added check for the current Posting Date before Invoice Printing Out
    // 
    // 04.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Importance=Promoted set for "Location Code" field
    // 
    // 03.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Importance=Standard set for field "Posting Date"
    // 
    // 31.03.2014 Elva Baltic P18 MMG7.00
    //   Added fields
    //     ShortcutDimCode[3]..[8]
    //     "Invoice No."
    //   Added Code to
    //     OnAfterGetRecord()
    // 
    // 30.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Importance set to Promoted for field "Vehicle Registration No."
    // 
    // 28.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     OnDeleteRecord
    // 
    // 26.03.2014 Elva Baltic P18 #RX026 MMG7.00
    //   Added Fields To Details group
    //     "First Allocation Date"
    //     "First Allocation Time"
    // 
    // 25.03.2014 Elva Baltic P18 #RX025 MMG7.00
    //   Added New Page Actions
    //     Vehicle Comments
    //     Bill-To Customer Comments
    //     Sell-To Customer Comments
    // 
    // 24.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     Internal
    //   Added Page Action:
    //     UpdateItemUnitPrice
    //   Added functions:
    //     UpdateItemUnitPrice()
    //     CheckItemPriceLastUpdateTime()
    //   Added Code to:
    //     <Action75> - OnAction()    (Post)
    //     <Action76> - OnAction()    (Post and Print)
    // 
    // 24.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Fixed "Document Info" FactBox link
    // 
    // 22.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   *"Deal Type" field moved to the general tab
    //   *Visible=Fasles set to Prepayment and Foreign Trade tabs
    //   *Changed FactBox order
    //   *The following fields set Visible=FALSE:
    //    - Description
    //    - "Responsibility Center"
    //    - "No. of Archived Versions"
    //    - "Planned Service Date"
    //   *Importance property set to Standard for fields:
    //    - Order Date
    //    - Order Time
    //    - Phone No.
    //    - "Sell-to Contact No."
    //    - "Sell-to Contact"
    //   *Importance property set to Additional for fields:
    //    - Posting Date
    //   *Added print actions: Service Order, Invoice, Item Order
    // 
    // 20.03.2014 Elva Baltic P7 #R165 MMG7.00
    //   * Fields Added:
    //     -Bank No.
    //     -Bank Name
    //     -Bank Account No.
    //     -IBAN
    //     -Bank Branch No.
    //     -SWIFT Code
    // 
    // 18.03.2014 Elva Baltic P18 #RX003 MMG7.00
    //   Added group "LV Invoice"
    // 
    // 13.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * Field "Payment Method" moved to General Tab
    // 
    // 11.03.2014 Elva Baltic P7 #F107 MMG7.00
    //   * New function added - generate Prepayment
    //   * New field added generated invoice count
    // 
    // 07.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified trigger:
    //     <Action1101904013> - OnAction() (Create Transfer Order)
    //     Message was added to function ServTransfMgt.CreateTransferOrder
    // 
    // 03.03.2014 MMG7.1.00 P7 #R114
    //   * New function use FakePrepayment.
    // 
    // 22.01.2014 MMG7.1.00 P8 F029
    //   * New function use FakePrepayment.
    // 
    // 12.08.2013 EDMS P8
    //   * REMOVED MILLISECONDS
    // 
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3
    // 
    // 23.12.2011 EDMS P8
    //   * Add function: split document

    Caption = 'Service Order';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Vehicle Diagnosis/Checklist,History';
    RefreshOnActivate = true;
    SourceTable = Table25006145;
    SourceTableView = WHERE(Document Type=FILTER(Order));

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
                    Visible = true;
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
                    Visible = false;
                }
                field("Sell-to City";"Sell-to City")
                {
                    Importance = Additional;
                }
                field("Sell-to Contact No.";"Sell-to Contact No.")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("Ship Add Name 2";"Ship Add Name 2")
                {
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    Importance = Standard;
                }
                field("Mobile No. for SMS";"Mobile No. for SMS")
                {
                }
                field("Phone No.";"Phone No.")
                {
                    Importance = Standard;
                }
                field("Planned Service Date";"Planned Service Date")
                {
                    Visible = false;
                }
                field("Vehicle Serial No.";"Vehicle Serial No.")
                {
                    Enabled = false;
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
                field("Model Version No.";"Model Version No.")
                {
                    LookupPageID = "Model Version List";
                }
                field("Hour Reading";"Hour Reading")
                {
                    Importance = Additional;
                }
                field(Kilometrage;Kilometrage)
                {
                }
                field("Posting Date";"Posting Date")
                {
                    Importance = Additional;
                }
                field("Order Date";"Order Date")
                {
                    Importance = Standard;
                }
                field("Order Time";"Order Time")
                {
                    Importance = Additional;
                }
                field("Work Status Code";"Work Status Code")
                {
                }
                field("Service Person";"Service Person")
                {
                }
                field("Driver Name";"Driver Name")
                {
                }
                field("Driver Contact No.";"Driver Contact No.")
                {
                }
                field("Scheme Code";"Scheme Code")
                {
                    Editable = false;
                }
                field("Membership No.";"Membership No.")
                {
                    Editable = false;
                }
                field("Accountability Center";"Accountability Center")
                {
                }
                field("Payment Method Code";"Payment Method Code")
                {
                }
                field("Promised Delivery Date";"Promised Delivery Date")
                {
                }
                field("Promised Delivery Time";"Promised Delivery Time")
                {
                }
                field("Delay Reason Code";"Delay Reason Code")
                {
                    Caption = 'Delay Reason Code';
                    OptionCaption = ' ,Aggregate Repairs, Bodyshop / Panel Repairs, Delay in Customer Approval, Diagnosis Issue - Electronic, Diagnosis Issue - Mechanical, Major Job, Outside Jobs, Parts Not Available, Ready But Not Delivered, Work delayed - Tools availability, Work not started - manpower issue, Work not started - shopfloor overloaded, Work not started - walk-in customer, Work started but not completed, Others';
                }
                field(Remarks;Remarks)
                {
                    Importance = Additional;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    Visible = true;
                }
                field("Job Category";"Job Category")
                {
                    OptionCaption = ' ,Under Warranty,Post Warranty,Accidental Repair,PDI,DSS';
                }
                field("Job Type";"Job Type")
                {

                    trigger OnValidate()
                    begin
                        IF "Job Type" IN ['PDI','PDM'] THEN BEGIN
                          BalkumariWOVisible := TRUE;
                        END
                        ELSE
                          BalkumariWOVisible := FALSE;
                    end;
                }
                field("Service Type";"Service Type")
                {
                }
                field("RV RR Code";"RV RR Code")
                {
                    Editable = false;
                    Importance = Promoted;
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field(RevisitRepairReason;RevisitRepairReason)
                {
                    Caption = 'Revisit Repair Reason';

                    trigger OnDrillDown()
                    var
                        PSFVar: Record "33019806";
                    begin
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF PAGE.RUNMODAL(PAGE::"PSF Master",PsfVat)=ACTION::LookupOK THEN
                         RevisitRepairReason := PsfVat.Code;
                    end;
                }
                field("Next Service Date";"Next Service Date")
                {
                }
                field("Activity Detail";"Activity Detail")
                {
                    Importance = Additional;
                    Visible = true;
                }
                field("Approx. Estimation";"Approx. Estimation")
                {
                }
                field("Arrival Date";"Arrival Date")
                {
                }
                field("Arrival Time";"Arrival Time")
                {
                }
                field("Customer Price Group";"Customer Price Group")
                {
                    Importance = Additional;
                }
                field("External Document No.";"External Document No.")
                {
                    Importance = Additional;
                }
                field("Job Description";"Job Description")
                {
                    Importance = Additional;
                }
                field("Job Finished Date";"Job Finished Date")
                {
                }
                field("Job Finished Time";"Job Finished Time")
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
                    Importance = Additional;
                }
                field("Quality Control";"Quality Control")
                {
                }
                field("Floor Control";"Floor Control")
                {
                }
                field("Resources PSF";"Resources PSF")
                {
                }
                field("Insurance Type";"Insurance Type")
                {
                    Editable = false;
                }
                field("Insurance Company Name";"Insurance Company Name")
                {
                    Editable = false;
                }
                field("Insurance Policy Number";"Insurance Policy Number")
                {
                    Editable = false;
                }
            }
            part(ServiceLines;25006184)
            {
                SubPageLink = Document No.=FIELD(No.);
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                Visible = false;
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
                Visible = true;
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
                field("Finished Quantity (Hours)";"Finished Quantity (Hours)")
                {
                }
                field("Finished Travel Qty (Hours)";"Finished Travel Qty (Hours)")
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
                        "Resources PSF" := Resources;
                    end;
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
            part("Service Document FactBox EDMS";25006253)
            {
                SubPageLink = Document Type=FIELD(Document Type), No.=FIELD(No.);
                Visible = true;
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
                SubPageLink = Document Type=FIELD(Document Type), Document No.=FIELD(Document No.), Line No.=FIELD(Line No.);
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
                SubPageLink = Table ID=CONST(36), Document Type=FIELD(Document Type), Document No.=FIELD(No.), Status=CONST(Open);
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
                SubPageLink = Source Type=CONST(25006005), Source Subtype=CONST(0), Source ID=FIELD(Vehicle Serial No.), Source Ref. No.=CONST(0);
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
                    Visible = false;

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
                action("&Diagnosis")
                {
                    Caption = '&Diagnosis';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=CONST(Service Order), No.=FIELD(No.);
                }
                action(VehicleComment)
                {
                    Caption = 'Vehicle Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=CONST(Vehicle), No.=FIELD(Vehicle Serial No.);
                }
                action(BillToCustomerComment)
                {
                    Caption = 'Bill-To Customer Comments';
                    Image = ViewComments;
                    RunObject = Page 124;
                                    RunPageLink = Table Name=CONST(Customer), No.=FIELD(Bill-to Customer No.);
                }
                action(SelllToCustomerComment)
                {
                    Caption = 'Sell-To Customer Comments';
                    Image = ViewComments;
                    RunObject = Page 124;
                                    RunPageLink = Table Name=CONST(Customer), No.=FIELD(Sell-to Customer No.);
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
                action("A&pprovals")
                {
                    Caption = 'A&pprovals';
                    Image = Approvals;
                    Visible = false;

                    trigger OnAction()
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Service Header EDMS","Document Type","No.");
                        ApprovalEntries.RUN;
                    end;
                }
                action("Order &Promising")
                {
                    Caption = 'Order &Promising';
                    Image = OrderPromising;
                    Visible = false;

                    trigger OnAction()
                    var
                        OrderPromisingLine: Record "99000880" temporary;
                    begin
                        OrderPromisingLine.SETRANGE("Source Type",OrderPromisingLine."Source Type"::"Service Order EDMS");     // 26.02.2015 EDMS P21
                        OrderPromisingLine.SETRANGE("Source ID","No.");
                        PAGE.RUNMODAL(PAGE::"Order Promising Lines",OrderPromisingLine);
                    end;
                }
                action("<Action1102159014>")
                {
                    Caption = '&External Service Ledger';
                    RunObject = Page 25006223;
                                    RunPageLink = Service Order No.=FIELD(No.);
                }
                action("<Action1102159018>")
                {
                    Caption = 'Purchase Orders';
                    RunObject = Page 33019837;
                                    RunPageLink = Service Order No.=FIELD(No.);
                }
                action("SIE Assigtments")
                {
                    Caption = 'SIE Assigtments';
                    Image = Journals;

                    trigger OnAction()
                    begin
                        ShowSIEAssgnt;
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
            group("Speci&al Order")
            {
                Caption = 'Speci&al Order';
                action(SpecPurchOrder)
                {
                    Caption = 'Purchase &Order';
                    Image = Document;

                    trigger OnAction()
                    begin
                        CurrPage.ServiceLines.PAGE.OpenSpecialPurchOrderForm;
                    end;
                }
            }
            group(Transfers)
            {
                Caption = 'Transfers';
                action("Transfer Orders")
                {
                    Caption = 'Transfer Orders';
                    Image = Documents;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupOrdTransf(Rec)
                    end;
                }
                action("Transfer Shipments")
                {
                    Caption = 'Transfer Shipments';
                    Image = PostedReceipts;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupTransferShipment(Rec)
                    end;
                }
                action("Transfer Receipts")
                {
                    Caption = 'Transfer Receipts';
                    Image = PostedReceipts;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupTransferReceipt(Rec)
                    end;
                }
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                Visible = false;
                action("<Action234>")
                {
                    Caption = 'Prepa&yment Invoices';
                    Image = PrepaymentInvoice;
                    RunObject = Page 143;
                                    RunPageLink = Prepayment Order No.=FIELD(No.);
                    RunPageView = SORTING(Prepayment Order No.);
                    Visible = false;
                }
                action("<Action235>")
                {
                    Caption = 'Prepayment Credi&t Memos';
                    Image = PrepaymentCreditMemo;
                    RunObject = Page 144;
                                    RunPageLink = Prepayment Order No.=FIELD(No.);
                    RunPageView = SORTING(Prepayment Order No.);
                    Visible = false;
                }
            }
            group(Schedule)
            {
                Caption = 'Schedule';
                action("Send SMS")
                {
                    Caption = 'Send SMS';
                    Image = SendConfirmation;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    var
                        SysMgt: Codeunit "50000";
                    begin
                        SendSMS;
                    end;
                }
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
                action("Resource Time Reg. Entries")
                {
                    Caption = 'Resource Time Reg. Entries';
                    RunObject = Page 25006295;
                                    RunPageLink = Source Type=CONST(Service Document), Source Subtype=CONST(Order), Source ID=FIELD(No.);
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
                    Visible = false;
                }
                action(Pictures)
                {
                    Caption = 'Pictures';
                    Image = Picture;
                    RunObject = Page 25006059;
                                    RunPageLink = Source Type=CONST(25006005), Source Subtype=CONST(0), Source ID=FIELD(Vehicle Serial No.), Source Ref. No.=CONST(0);
                    RunPageMode = View;
                }
            }
        }
        area(processing)
        {
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
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
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Vehicle History")
                {
                    Caption = 'Vehicle History';
                    Image = History;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Vehicle: Record "25006005";
                    begin
                        Vehicle.RESET;
                        Vehicle.SETRANGE("Serial No.","Vehicle Serial No.");
                        IF Vehicle.FINDFIRST THEN
                          REPORT.RUNMODAL(33020241,TRUE,FALSE,Vehicle);
                    end;
                }
                action("<Action67>")
                {
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;
                    Visible = false;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                    end;
                }
                action(SplitDocument)
                {
                    Caption = 'Split Document';
                    Ellipsis = true;
                    Image = Splitlines;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ServiceSplittingLine.LOCKTABLE;                                                           // 06.05.2014 Elva Baltic P21
                        ServiceSplittingLine.RESET;                                                               // 06.05.2014 Elva Baltic P21
                        ServiceSplittingLine.OpenFormForServDoc(Rec);
                    end;
                }
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
                action(CreateTransferOrder)
                {
                    Caption = 'Create Transfer Order';
                    Image = CreateInventoryPickup;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServLine: Record "25006146";
                        ServTransfMgt: Codeunit "25006010";
                    begin
                        CurrPage.ServiceLines.PAGE.SetRecSelectionFilter(ServLine);

                        ServTransfMgt.SetTransferLineSelection(ServLine);

                        // 07.03.2014 Elva Baltic P21 >>
                        // IF ServTransfMgt.CreateTransferOrder(Rec) THEN
                        //   MESSAGE(Text101);
                        ServTransfMgt.CreateTransferOrder(Rec);
                        // 07.03.2014 Elva Baltic P21 <<

                        IF ServTransfMgt.GetServiceChangeInfo THEN
                          MESSAGE(Text102);
                    end;
                }
                action("<Action1101904007>")
                {
                    Caption = 'Item Order Overview';
                    Image = ItemTrackingLines;
                    Visible = false;

                    trigger OnAction()
                    var
                        ItemOrderOverview: Page "25006805";
                    begin
                        ItemOrderOverview.SetSourceType2(2); //Service
                        ItemOrderOverview.SetDocumentFilter("No.");
                        ItemOrderOverview.SetFilters;
                        ItemOrderOverview.FindRec;
                        ItemOrderOverview.RUN;
                    end;
                }
                action(UpdateItemUnitPrice)
                {
                    Caption = 'Update Item Unit Price';
                    Image = UpdateUnitCost;

                    trigger OnAction()
                    begin
                        UpdateItemUnitPrice;
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
                action("Send SMS 2")
                {
                    Caption = 'Send SMS 2';
                    Image = SendTo;
                    Visible = false;

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
                action("<Action1102159007>")
                {
                    Caption = '&Diagnosis';
                    Image = Components;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=FIELD(Document Type), No.=FIELD(No.);
                    ShortCutKey = 'Ctrl+D';
                }
                action("<Action1102159008>")
                {
                    Caption = 'Inventory Checklists';
                    Image = PhysicalInventory;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page 25006010;
                                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.), Source ID=FIELD(No.);
                    ShortCutKey = 'Ctrl+I';
                }
                action("Consumption Checklist")
                {
                    Caption = 'Consumption Checklist';
                    Image = Description;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page 33020580;
                                    RunPageLink = Job Card No.=FIELD(No.);
                }
                action("Print Consumption")
                {
                    Caption = 'Print Consumption';
                    Image = PrintAcknowledgement;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Consumption: Record "33020528";
                    begin
                        Consumption.RESET;
                        Consumption.SETRANGE("Job Card No.","No.");
                        REPORT.RUNMODAL(33020206,TRUE,FALSE,Consumption);
                    end;
                }
                action("&Service Plan")
                {
                    Caption = '&Service Plan';
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        ServInfoPaneMgt.LookupServicePlans(Rec)
                    end;
                }
                action("<Action1102159011>")
                {
                    Caption = '&Warranty Status';
                    Image = ChangeStatus;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 33020238;
                                    RunPageLink = Document Type=FIELD(Document Type), Document No.=FIELD(No.);
                    RunPageView = SORTING(Document Type,Document No.,Line No.) WHERE(Need Approval=CONST(Yes));
                }
                action("<Action1102159017>")
                {
                    Caption = 'Create &Purchase Order';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        CODEUNIT.RUN(CODEUNIT::"External Service Mgt.",Rec);
                    end;
                }
                action("<Action1102159027>")
                {
                    Caption = 'Send Document Approval Request';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        InsertWarrantyApproval(Rec);
                    end;
                }
                action("Close Job")
                {
                    Caption = 'Close Job';
                    Image = Cancel;
                    RunObject = Page 33020245;
                                    RunPageLink = Service Order No.=FIELD(No.);
                }
            }
            group(Plan)
            {
                Caption = 'Plan';
                action("<Action1101904031>")
                {
                    Caption = 'Schedule';
                    Image = Planning;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006358;
                                    RunPageLink = Document Type=FIELD(Document Type), No.=FIELD(No.);
                    RunPageOnRec = true;
                    ShortCutKey = 'Ctrl+S';

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "25006358";
                    begin
                        //ServiceSchedule.SetServiceHeader(Rec);
                        //ServiceSchedule.RUN;
                    end;
                }
                action("Order &Promising")
                {
                    Caption = 'Order &Promising';
                    Image = OrderPromising;
                    Visible = false;

                    trigger OnAction()
                    var
                        OrderPromisingLine: Record "99000880" temporary;
                    begin
                        OrderPromisingLine.SETRANGE("Source Type",OrderPromisingLine."Source Type"::"Service Order EDMS");     // 26.02.2015 EDMS P21
                        OrderPromisingLine.SETRANGE("Source ID","No.");
                        PAGE.RUNMODAL(PAGE::"Order Promising Lines",OrderPromisingLine);
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
                action("Remove Service Package")
                {
                    Caption = 'Remove Service Package';
                    Visible = false;

                    trigger OnAction()
                    begin
                        RemoveServPackage(TRUE);
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
            group(Request)
            {
                Caption = 'Request';
                Image = SendApprovalRequest;
                Visible = false;
                action("<Action1250>")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.SendServEDMSApprovalRequest(Rec) THEN;
                    end;
                }
                action("<Action1251>")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //IF ApprovalMgt.CancelServEDMSApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action(Post)
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        DefectRec: Record "14125606";
                    begin
                          IF NOT "Km Error" THEN BEGIN
                             "Km Error" := TRUE;
                             MODIFY;
                             COMMIT;
                               ERROR('Please Verify the KM.');
                           END;
                          IF "RV RR Code" = "RV RR Code"::" " THEN //PSF1.0
                           verifyIfItsRepatAlreadyDOC(Rec);

                          DefectRec.RESET;
                          DefectRec.SETRANGE("Service Order No.", Rec."No.");
                          DefectRec.SETFILTER("RV RR Code",'<>%1',DefectRec."RV RR Code"::" ");
                          IF DefectRec.FINDSET THEN REPEAT
                             DefectRec.TESTFIELD("RV RR Justification");
                            UNTIL DefectRec.NEXT = 0;

                        COMMIT;


                        //AGNI UPG 2009
                        ServLine.RESET;
                        ServLine.SETRANGE("Document No.","No.");
                        ServLine.SETFILTER(Type,'<>''''');
                        ServLine.SETFILTER("No.",'<>''''');
                        IF ServLine.FINDFIRST THEN REPEAT
                           ServLine.TESTFIELD("Job Type");
                        UNTIL ServLine.NEXT = 0;


                        //AGNI UPG 2009


                        //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN BEGIN
                        //  IF ApprovalMgt.TestServPrepayment(Rec) THEN
                        //    ERROR(STRSUBSTNO(Text001,"Document Type","No."))
                        //  ELSE BEGIN
                        //    IF ApprovalMgt.TestServPayment(Rec) THEN
                        //      ERROR(STRSUBSTNO(Text002,"Document Type","No."))
                        //    ELSE
                              CODEUNIT.RUN(CODEUNIT::"Service-Post (Yes/No) EDMS",Rec);
                        //  END;
                        //END;
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    Visible = false;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "38";
                    begin
                        //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN BEGIN
                        //  IF ApprovalMgt.TestServPrepayment(Rec) THEN
                        //    ERROR(STRSUBSTNO(Text001,"Document Type","No."))
                        //  ELSE BEGIN
                        //    IF ApprovalMgt.TestServPayment(Rec) THEN
                        //      ERROR(STRSUBSTNO(Text002,"Document Type","No."))
                        //    ELSE
                              CODEUNIT.RUN(CODEUNIT::"Service-Post+Print EDMS",Rec);
                        //  END;
                        //END;
                    end;
                }
                group("Prepa&yment")
                {
                    Caption = 'Prepa&yment';
                    Image = Prepayment;
                    Visible = false;
                    action("Advanced Prepayment")
                    {
                        Caption = 'Advanced Prepayment';
                    }
                    action("<Action231>")
                    {
                        Caption = 'Prepayment &Test Report';
                        Ellipsis = true;
                        Image = PrepaymentSimulation;

                        trigger OnAction()
                        begin
                            ReportPrint.PrintServiceHeaderPrepmt(Rec);
                        end;
                    }
                    action("<Action232>")
                    {
                        Caption = 'Post Prepayment &Invoice';
                        Ellipsis = true;
                        Image = PrepaymentPost;

                        trigger OnAction()
                        var
                            PurchaseHeader: Record "38";
                            SalesPostYNPrepmt: Codeunit "443";
                        begin
                            //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN
                              ServPostYNPrepmt.PostPrepmtInvoiceYN(Rec,FALSE);
                        end;
                    }
                    action("<Action237>")
                    {
                        Caption = 'Post and Print Prepmt. Invoic&e';
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;

                        trigger OnAction()
                        var
                            PurchaseHeader: Record "38";
                            SalesPostYNPrepmt: Codeunit "443";
                        begin
                            //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN
                              ServPostYNPrepmt.PostPrepmtInvoiceYN(Rec,TRUE);
                        end;
                    }
                    action("<Action233>")
                    {
                        Caption = 'Post Prepayment &Credit Memo';
                        Ellipsis = true;
                        Image = PrepaymentPost;

                        trigger OnAction()
                        var
                            OldCorr: Boolean;
                        begin
                            OldCorr := Correction;
                            Correction := FALSE;
                            //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN
                              ServPostYNPrepmt.PostPrepmtCrMemoYN(Rec,FALSE);
                            Correction := OldCorr;
                            MODIFY
                        end;
                    }
                    action("<Action238>")
                    {
                        Caption = 'Post and Print Prepmt. Cr. Mem&o';
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;

                        trigger OnAction()
                        var
                            OldCorr: Boolean;
                        begin
                            OldCorr := Correction;
                            Correction := FALSE;
                            //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN
                              ServPostYNPrepmt.PostPrepmtCrMemoYN(Rec,TRUE);
                            Correction := OldCorr;
                            MODIFY
                        end;
                    }
                    action("<Action1101901025>")
                    {
                        Caption = 'Post Prepayment C&or. Credit Memo';
                        Image = PrepaymentPost;

                        trigger OnAction()
                        var
                            OldCorr: Boolean;
                        begin
                            OldCorr := Correction;
                            Correction := TRUE;
                            //IF ApprovalMgt.PrePostServApprCheck(Rec) THEN
                              ServPostYNPrepmt.PostPrepmtCrMemoYN(Rec,FALSE);
                            Correction := OldCorr;
                            MODIFY
                        end;
                    }
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                action("Job Slip")
                {
                    Caption = 'Job Slip';
                    Image = Agreement;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                    trigger OnAction()
                    var
                        ServLine: Record "25006146";
                        DocMgt: Codeunit "25006000";
                        DocReport: Record "25006011";
                        ServHeaders: Record "25006145";
                    begin
                        /*
                        ServLine.RESET;
                        DocMgt.PrintCurrentDoc(3, 3, 1, DocReport);
                        DocMgt.SelectServDocReport(DocReport, Rec, ServLine,FALSE);
                        */
                        
                        CurrPage.SETSELECTIONFILTER(ServHeaders);
                        REPORT.RUNMODAL(33020239,TRUE,FALSE,ServHeaders);

                    end;
                }
                action(Email)
                {
                    Caption = 'Email';
                    Image = SendEmailPDF;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        ServLine: Record "25006146";
                        DocMgt: Codeunit "25006000";
                        DocReport: Record "25006011";
                    begin
                        ServLine.RESET;
                        DocMgt.PrintCurrentDoc(3, 3, 1, DocReport);
                        DocMgt.SelectServDocReport(DocReport, Rec, ServLine,TRUE);
                    end;
                }
                action("Print & Sign")
                {
                    Caption = 'Print & Sign';
                    Image = Signature;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        SignManagement: Codeunit "25006213";
                    begin
                        SignManagement.CallSignAndPrintPageService(Rec);
                    end;
                }
                action("Washing Slip")
                {
                    Caption = 'Washing Slip';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = "Report";
                    Visible = false;

                    trigger OnAction()
                    var
                        ServHeaders: Record "25006145";
                    begin
                        CurrPage.SETSELECTIONFILTER(ServHeaders);
                        REPORT.RUNMODAL(33020242,TRUE,FALSE,ServHeaders);
                    end;
                }
                action("<Action1102159012>")
                {
                    Caption = 'Work Order';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Page 33020249;
                                    RunPageLink = Service Order No.=FIELD(No.);
                    Visible = false;

                    trigger OnAction()
                    var
                        ServHeaders: Record "25006145";
                    begin
                        //CurrPage.SETSELECTIONFILTER(ServHeaders);
                        //REPORT.RUNMODAL(33020238,TRUE,FALSE,ServHeaders);
                    end;
                }
                action("STPL Balkumari Work Order")
                {
                    Caption = 'STPL Balkumari Work Order';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Page 33020257;
                                    RunPageLink = Service Order No.=FIELD(No.);
                    Visible = false;
                }
                action("<Action1102159019>")
                {
                    Caption = 'Job Order';
                    Description = 'ServiceAgreement';
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    var
                        ServHeaders: Record "25006145";
                    begin
                        CurrPage.SETSELECTIONFILTER(ServHeaders);
                        REPORT.RUNMODAL(33020240,TRUE,FALSE,ServHeaders);
                    end;
                }
                action("Pro-Forma Invoice")
                {
                    Caption = 'Pro-Forma Invoice';
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    var
                        ServHeaders: Record "25006145";
                    begin

                        CurrPage.SETSELECTIONFILTER(ServHeaders);
                        REPORT.RUNMODAL(33020244,TRUE,FALSE,ServHeaders);
                    end;
                }
                action("Update Resources in Line")
                {
                    Ellipsis = false;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = New;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;
                    //The property 'PromotedOnly' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedOnly = false;
                    Visible = false;

                    trigger OnAction()
                    var
                        ServHdrEDMS: Record "25006145";
                        ServLineEDMS: Record "25006146";
                        ResourcesVar: Text;
                    begin
                        ServHdrEDMS.RESET;
                        ServHdrEDMS.SETRANGE("Document Type",ServHdrEDMS."Document Type"::Order);
                        IF ServHdrEDMS.FINDFIRST THEN REPEAT
                          ServLineEDMS.RESET;
                          ServLineEDMS.SETRANGE("Document Type",ServHdrEDMS."Document Type");
                          ServLineEDMS.SETRANGE("Document No.",ServHdrEDMS."No.");
                          ServLineEDMS.SETRANGE(Type,ServLineEDMS.Type::Labor);
                          IF ServLineEDMS.FINDFIRST THEN REPEAT
                            ResourcesVar := '';
                            ResourcesVar := ServLineEDMS.GetResourceTextFieldValue;
                            ServLineEDMS.Resources := FORMAT(ResourcesVar);
                            ServLineEDMS.MODIFY;
                          UNTIL ServLineEDMS.NEXT = 0;
                        UNTIL ServHdrEDMS.NEXT = 0;
                        /*ServLineEDMS.RESET;
                        ServLineEDMS.SETRANGE("Document Type",ServLineEDMS."Document Type"::Order);
                        ServLineEDMS.SETFILTER(Resources,'*BAY*');
                        IF ServLineEDMS.FINDFIRST THEN REPEAT
                        UNTIL ServLineEDMS.NEXT  =0;*/
                        MESSAGE('Successfull');

                    end;
                }
                action("Defect And Complain")
                {
                    Image = Evaluate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        DefectPage: Page "14125504";
                    begin
                        CLEAR(DefectPage);
                        Rec.TESTFIELD(VIN);
                        DefectPage.insertHeaderNo(Rec."No.",Rec.VIN);
                        DefectPage.RUN;
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
                            //AASTHA UPG
        IF ServiceHeaderEDMSExt.GET(Rec."Document Type",Rec."No.") THEN BEGIN
        DelayReasonCode := ServiceHeaderEDMSExt."Delay Reason Code";
        ResourcePSFCode:= ServiceHeaderEDMSExt."Resources PSF";
        RevisitRepairReason:= ServiceHeaderEDMSExt."Revisit Repair Reason";
        KmError:= ServiceHeaderEDMSExt."Km Error";
        InsuranceCompanyName:= ServiceHeaderEDMSExt."Insurance Company Name";
        InsurancePolicyNumber:=ServiceHeaderEDMSExt."Insurance Policy Number";
        END;
                                 //AASTHA UPG
        ShowShortcutDimCode(ShortcutDimCode); // 31.03.2014 Elva Baltic P18 MMG7.00
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        LostSaleMgt.OnServHeaderDelete(Rec);
                           //AASTHA UPG
                           //-------------BishwasK
        IF ServiceHeaderEDMSExt.GET(Rec."Document Type",Rec."No.") THEN
          ServiceHeaderEDMSExt.DELETE;
                           //AASTHA UPG
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
        //VALIDATE("Work Status Code",'BOOKING'); Do not Book When Direct Service Order is Opened.
                           //AASTHA UPG
        //Uttam
        IF (ResourcePSFCode <> '') OR (RevisitRepairReason <>'') OR (InsuranceCompanyName <>'') OR (InsurancePolicyNumber <> '') THEN BEGIN
        ServiceHeaderEDMSExt."Document Type":= Rec."Document Type";
        ServiceHeaderEDMSExt."Sell-to Customer No.":= Rec."Sell-to Contact No.";
        ServiceHeaderEDMSExt."Delay Reason Code":= DelayReasonCode;
        ServiceHeaderEDMSExt."Resources PSF":= ResourcePSFCode;
        ServiceHeaderEDMSExt."Revisit Repair Reason":= RevisitRepairReason;
        ServiceHeaderEDMSExt."Km Error":= KmError;
        ServiceHeaderEDMSExt."Insurance Company Name":= InsuranceCompanyName;
        ServiceHeaderEDMSExt."Insurance Policy Number":= InsurancePolicyNumber;
        ServiceHeaderEDMSExt.INSERT;
        END;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //----------------BishwasK
        IF (ResourcePSFCode <> '') OR (RevisitRepairReason <> '') OR (InsuranceCompanyName <> '') OR (InsurancePolicyNumber <> '') THEN
            IF ServiceHeaderEDMSExt.GET(Rec."Document Type",Rec."No.") THEN BEGIN
            ServiceHeaderEDMSExt."Delay Reason Code":= DelayReasonCode;
            ServiceHeaderEDMSExt."Resources PSF":= ResourcePSFCode;
            ServiceHeaderEDMSExt."Revisit Repair Reason":= RevisitRepairReason;
            ServiceHeaderEDMSExt."Km Error":= KmError;
            ServiceHeaderEDMSExt."Insurance Company Name":= InsuranceCompanyName;
            ServiceHeaderEDMSExt."Insurance Policy Number":= InsurancePolicyNumber;
            ServiceHeaderEDMSExt.MODIFY;
            END;
            //AASTHA UPG
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        /*
        "Responsibility Center" := UserMgt.GetSalesFilter;
        //AGNI 2009 UPG
        */
        IF NOT UserMgt.DefaultResponsibility THEN
          "Accountability Center" := UserMgt.GetServiceFilterEDMS()
        ELSE
          "Responsibility Center" := UserMgt.GetServiceFilterEDMS();
        
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
        */ //Agni UPG 2009
        FilterOnRecord;
        SETRANGE("Date Filter",0D,WORKDATE - 1);
        
        SetDocNoVisible;
        //AASTHA UPG
        //--------------BishwasK------------------------------
        IF ServiceHeaderEDMSExt.GET(Rec."Document Type",Rec."No.") THEN BEGIN
        DelayReasonCode := ServiceHeaderEDMSExt."Delay Reason Code";
        ResourcePSFCode:= ServiceHeaderEDMSExt."Resources PSF";
        RevisitRepairReason:= ServiceHeaderEDMSExt."Revisit Repair Reason";
        KmError:= ServiceHeaderEDMSExt."Km Error";
        InsuranceCompanyName:= ServiceHeaderEDMSExt."Insurance Company Name";
        InsurancePolicyNumber:=ServiceHeaderEDMSExt."Insurance Policy Number";
        END;
        //AASTHA UPG

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
        UserSetup: Record "91";
        Location: Record "14";
        [InDataSet]
        BalkumariWOVisible: Boolean;
        ServLine: Record "25006146";
        DelayReasonCode: Option " ","Aggregate Repairs"," Bodyshop / Panel Repairs"," Delay in Customer Approval"," Diagnosis Issue - Electronic"," Diagnosis Issue - Mechanical"," Major Job"," Outside Jobs"," Parts Not Available"," Ready But Not Delivered"," Work delayed - Tools availability"," Work not started - manpower issue"," Work not started - shopfloor overloaded"," Work not started - walk-in customer"," Work started but not completed"," Others";
        ResourcePSFCode: Code[20];
        RevisitRepairReason: Code[20];
        KmError: Boolean;
        InsuranceCompanyName: Text[30];
        InsurancePolicyNumber: Code[20];
        ServiceHeaderEDMSExt: Record "25006572";
        PsfVat: Record "33019806";

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
        CurrPage."Service Document FactBox EDMS".PAGE.UpdateForm(TRUE);
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
        DocType: Option Quote,"Order","Return Order";
    begin
        //DocNoVisible := DocumentNoVisibility.ServiceDocumentNoIsVisible(DocType::Order,"No.");
        DocNoVisible := TRUE;
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

