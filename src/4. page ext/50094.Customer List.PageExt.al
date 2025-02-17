pageextension 50094 pageextension50094 extends "Customer List"
{
    // 28.06.2013 EDMS P8
    //   * Added action 'Vehicles'
    Editable = false;
    Editable = false;
    Editable = true;
    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "Control 35".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 33".


        //Unsupported feature: Property Modification (SubPageLink) on "SalesHistSelltoFactBox(Control 1903720907)".


        //Unsupported feature: Property Modification (SubPageLink) on "SalesHistBilltoFactBox(Control 1907234507)".


        //Unsupported feature: Property Modification (SubPageLink) on "CustomerStatisticsFactBox(Control 1902018507)".


        //Unsupported feature: Property Modification (SubPageLink) on "CustomerDetailsFactBox(Control 1900316107)".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1907829707".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1902613707".

        addafter("Control 4")
        {
            field("Name 2"; Rec."Name 2")
            {
            }
            field(Address; Rec.Address)
            {
            }
            field("Accountability Center"; "Accountability Center")
            {
                Visible = false;
            }
        }
        addafter("Control 32")
        {
            field("Citizenship No."; "Citizenship No.")
            {
                Visible = false;
            }
            field("Citizenship Issued District"; "Citizenship Issued District")
            {
                Visible = false;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
            }
            field("Sipradi Customer No."; "Sipradi Customer No.")
            {
                Visible = false;
            }
            field(Balance; Rec.Balance)
            {
            }
            field("Is Dealer"; "Is Dealer")
            {
            }
            field("Is Privilage"; "Is Privilage")
            {
            }
            field("Dealer Segment Type"; "Dealer Segment Type")
            {
            }
            field("Net Change"; Rec."Net Change")
            {
            }
            field(Section; Section)
            {
            }
            field("Net Change (LCY)"; Rec."Net Change (LCY)")
            {
            }
        }
        addafter("Control 62")
        {
            field("Province No."; "Province No.")
            {
            }
            field("Mobile No."; "Mobile No.")
            {
            }
            field("Credit Limit Total"; "Credit Limit Total")
            {
            }
        }
        addafter("Control 59")
        {
            field(Class; Class)
            {
            }
            field("Location Code for Dealer"; "Location Code for Dealer")
            {
            }
            field("Student Left  Date"; "Student Left  Date")
            {
            }
            field("Student Joining Date"; "Student Joining Date")
            {
            }
            field(Saved; Saved)
            {
                Editable = false;
            }
        }
        moveafter("Control 1102601016"; "Control 32")
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 20".


        //Unsupported feature: Property Modification (RunPageLink) on "DimensionsSingle(Action 84)".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 45".


        //Unsupported feature: Property Modification (RunPageView) on "CustomerLedgerEntries(Action 22)".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 18".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 21".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 19".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 63".


        //Unsupported feature: Property Modification (RunPageLink) on ""Sales_Prices"(Action 26)".


        //Unsupported feature: Property Modification (RunPageLink) on ""Sales_LineDiscounts"(Action 71)".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 82".


        //Unsupported feature: Property Modification (RunPageLink) on ""Prices_Prices"(Action 100)".


        //Unsupported feature: Property Modification (RunPageLink) on ""Prices_LineDiscounts"(Action 98)".

        addafter("Action 60")
        {
            action("&Vehicles")
            {
                Caption = '&Vehicles';
                Image = Delivery;

                trigger OnAction()
                begin
                    ShowVehicles;
                end;
            }
        }
        addafter("Action 1904039606")
        {
            action("Customer Detail Trial Balance")
            {

                trigger OnAction()
                var
                    DealerPurchaseIntegration: Codeunit "33020511";
                    Customer: Record "18";
                    DealerIntegrationService: Codeunit "33020507";
                begin
                    Customer.RESET;
                    Customer.SETRANGE("No.", Rec."No.");
                    // DealerPurchaseIntegration.GetCustomerDetail("No.",071520D);
                    // DealerPurchaseIntegration.SynchronizeReport;
                    DealerIntegrationService.SynchronizeReport;
                end;
            }
            action(SendMail)
            {
                Image = Mail;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesPost: Codeunit "80";
                    SalIn: Record "112";
                begin
                    SalIn.SETRANGE("No.", 'BIDDN70-00002');
                    IF SalIn.FINDFIRST THEN
                        SalesPost.SendTaxInvoiceAsPdfToCustomer(SalIn);
                end;
            }
            action("Cust Create")
            {
                Image = New;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Compinfo: Record "79";
                    Cust: Record "18";
                begin
                    Compinfo.GET;
                    IF Compinfo."Balaju Auto Works" THEN BEGIN
                        Cust.INIT;
                        Cust.INSERT(TRUE);
                        PAGE.RUN(PAGE::"Customer Card", Cust);
                        EXIT;
                    END;
                end;
            }
        }
    }

    var
        WarehouseEntryVar: Record "7312";
        ItemLedgerEntries: Record "32";


    //Unsupported feature: Code Insertion on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //var
    //Compinfo: Record "79";
    //Cust: Record "18";
    //begin
    /*
    */
    //end;
}

