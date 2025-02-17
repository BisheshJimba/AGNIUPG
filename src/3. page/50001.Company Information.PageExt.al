pageextension 50001 pageextension50001 extends "Company Information"
{
    // 18.05.2016 EB.P30 EDMS
    //   Added fields:
    //     "Invoice Header Picture"
    //     "Invoice Footer Picture"

    //Unsupported feature: Property Insertion (Permissions) on ""Company Information"(Page 1)".

    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 14".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 14".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 14".

        addafter("Control 33")
        {
            field("Picture 2"; "Picture 2")
            {
            }
            field("Phone Pay QR"; "Phone Pay QR")
            {
                Caption = 'Fone Pay QR';
            }
            field("Skip Specific Processes"; "Skip Specific Processes")
            {
            }
            field("Post Box No."; "Post Box No.")
            {
            }
        }
        addafter("Control 14")
        {
            field("Agni Astha Company"; "Agni Astha Company")
            {
            }
            field("Balaju Auto Works"; "Balaju Auto Works")
            {
            }
            field("Agni Hire Purchase Company"; "Agni Hire Purchase Company")
            {
            }
            field("Is Logistic"; "Is Logistic")
            {
            }
        }
        addafter("System Indicator Text")
        {
            field("Scheme Related Fields"; "Scheme Related Fields")
            {
            }
            group("CBMS Integration")
            {
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the company''s VAT registration number.';
                }
                field("CBMS Username"; "CBMS Username")
                {
                }
                field("CBMS Password"; "CBMS Password")
                {
                }
                field("CBMS Base URL"; "CBMS Base URL")
                {
                }
                field("Enable CBMS Realtime Sync"; "Enable CBMS Realtime Sync")
                {
                }
                field("IRD Code"; "IRD Code")
                {
                }
                field("Company Name(Devnagri)"; "Nepali Vat Reg. No.")
                {
                }
            }
            group("Connect IPS")
            {
                field("Enable NCHL-NPI Integration"; "Enable NCHL-NPI Integration")
                {
                }
            }
        }
        addafter("Control 38")
        {
            group("Report Design Templates")
            {
                Caption = 'Report Design Templates';
                field("Invoice Header Picture"; "Invoice Header Picture")
                {
                }
                field("Invoice Footer Picture"; "Invoice Footer Picture")
                {
                }
            }
        }
        moveafter("Control 10"; "Control 7")
    }
    actions
    {
        addafter("Action 5")
        {
            action(CBMS)
            {
                Image = "report";
                RunObject = Report 33020254;
            }
            action(InsertInvMatView)
            {
                Image = Insert;

                trigger OnAction()
                begin
                    //IRDMgt.InsertRegisterInvoice(DATABASE::"Sales Cr.Memo Header", 'BIDSPC78-00036'); //Min
                    //MESSAGE('Success !');
                end;
            }
            action("Update ")
            {

                trigger OnAction()
                begin
                    TemporaryProc.UpdateInstallMentNo;
                end;
            }
            action(UpdateNoOfPrint)
            {
                Visible = false;

                trigger OnAction()
                var
                    filterPage: FilterPageBuilder;
                    CustNo: Text;
                    SalInvHdr: Record "112";
                    SalInvHdrPage: Page "143";
                    NoPrinted: Integer;
                    SalInvHdr1: Record "112";
                    Noprint: Text;
                    DocNo: Code[20];
                begin
                    CLEAR(filterPage);
                    CLEAR(Noprint);
                    CLEAR(NoPrinted);
                    CLEAR(DocNo);
                    filterPage.ADDRECORD('Print', SalInvHdr);
                    filterPage.ADDFIELD('Print', SalInvHdr."No.");
                    filterPage.ADDFIELD('Print', SalInvHdr."No. Printed");
                    filterPage.RUNMODAL();
                    SalInvHdr.SETVIEW(filterPage.GETVIEW('Print'));
                    DocNo := SalInvHdr.GETFILTER("No.");
                    EVALUATE(NoPrinted, SalInvHdr.GETFILTER("No. Printed"));
                    IF (DocNo <> '') AND (NoPrinted <> 0) THEN BEGIN
                        IF SalInvHdr1.GET(DocNo) THEN BEGIN
                            SalInvHdr1."No. Printed" := NoPrinted;
                            SalInvHdr1.MODIFY;
                            MESSAGE('Done');
                        END;
                    END;
                end;
            }
        }
    }

    var
        Text001: Label 'Do you want to replace the existing picture?';
        Text002: Label 'Do you want to delete the picture?';
        IRDMgt: Codeunit "50000";
        Temp: Codeunit "33019834";
        TemporaryProc: Codeunit "50011";
}

