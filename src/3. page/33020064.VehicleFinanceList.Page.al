page 33020064 "Vehicle Finance List"
{
    CardPageID = "Vehicle Finance Application";
    PageType = List;
    SourceTable = Table33020073;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; "Application No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Contact No."; "Contact No.")
                {
                }
                field("Contact Name"; "Contact Name")
                {
                }
                field("Responsible Person Name"; "Responsible Person Name")
                {
                }
                field("Interest Rate"; "Interest Rate")
                {
                }
                field("Tenure in Months"; "Tenure in Months")
                {
                }
                field("Vehicle Cost"; "Vehicle Cost")
                {
                }
                field("Down Payment"; "Down Payment")
                {
                }
                field("Loan Amount"; "Loan Amount")
                {
                }
                field("Application Open Date"; "Application Open Date")
                {
                }
                field(Rejected; Rejected)
                {
                }
                field("Reason For Loan Rejection"; "Reason For Loan Rejection")
                {
                }
                field("Rejection Date"; "Rejection Date")
                {
                }
                field("Property NRV"; "Mortgage NRV")
                {
                    Caption = 'Property NRV';
                }
                field("Property Details"; "Mortgage Details")
                {
                    Caption = 'Property Details';
                }
            }
        }
        area(factboxes)
        {
            part(; 9084)
            {
            }
            systempart(; Notes)
            {
            }
            part(; 33020065)
            {
                SubPageLink = Serial No.=FIELD(Vehicle No.);
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Loan Processing Tracking Sheet")
            {
                Image = Timesheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    LoanProcTracking: Record "33020084";
                    LoanProcTrackingSheet: Page "33020286";
                    GeneralMaster: Record "33020061";
                    LoanProcTrackingRec: Record "33020084";
                    LineNo: Integer;
                begin
                    LoanProcTracking.RESET;
                    LoanProcTracking.SETRANGE("Application No.", "Application No.");
                    IF LoanProcTracking.FINDFIRST THEN BEGIN
                        InsertMissingLoanTrackingMaster(Rec); //SRT Dec 5th 2019
                        LoanProcTrackingSheet.SETRECORD(LoanProcTracking);
                        LoanProcTrackingSheet.SETTABLEVIEW(LoanProcTracking);
                        LoanProcTrackingSheet.RUN;
                    END ELSE BEGIN
                        GeneralMaster.RESET;
                        GeneralMaster.SETRANGE(Category, 'Vehicle Loan');
                        GeneralMaster.SETRANGE("Sub Category", 'Components');
                        GeneralMaster.SETRANGE(Disable, FALSE);
                        GeneralMaster.SETCURRENTKEY("Sequence No.");
                        IF GeneralMaster.FINDFIRST THEN BEGIN
                            LineNo := 10000;
                            REPEAT
                                LoanProcTrackingRec.INIT;
                                LoanProcTrackingRec."Application No." := "Application No.";
                                LoanProcTrackingRec."Line No." := LineNo;
                                LoanProcTrackingRec.Components := GeneralMaster.Code;
                                LoanProcTrackingRec."Components Description" := GeneralMaster.Description;
                                IF LoanProcTrackingRec."Line No." = 10000 THEN BEGIN
                                    LoanProcTrackingRec.Processed := TRUE;
                                    LoanProcTrackingRec."Processing Time" := 0;
                                    LoanProcTrackingRec.Date := TODAY;
                                    LoanProcTrackingRec."User Id" := USERID;
                                END;
                                LoanProcTrackingRec.INSERT;
                                LineNo := LineNo + 10000;

                            UNTIL GeneralMaster.NEXT = 0;
                        END;
                        LoanProcTracking.RESET;
                        LoanProcTracking.SETRANGE("Application No.", "Application No.");
                        IF LoanProcTracking.FINDFIRST THEN BEGIN
                            LoanProcTrackingSheet.SETRECORD(LoanProcTracking);
                            LoanProcTrackingSheet.SETTABLEVIEW(LoanProcTracking);
                            LoanProcTrackingSheet.RUN;
                        END;
                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Rejected THEN
            CurrPage.EDITABLE := FALSE
        ELSE
            CurrPage.EDITABLE := TRUE;
    end;

    trigger OnOpenPage()
    begin
        SETRANGE(Approved, FALSE);
    end;

    [Scope('Internal')]
    procedure InsertMissingLoanTrackingMaster(VehicleFinanceAppHeader: Record "33020073")
    var
        GeneralMaster: Record "33020061";
        LoanProcTrackingRec: Record "33020084";
        lineno: Integer;
    begin
        //SRT Dec 5th 2019 >>
        GeneralMaster.RESET;
        GeneralMaster.SETRANGE(Category, 'Vehicle Loan');
        GeneralMaster.SETRANGE("Sub Category", 'Components');
        GeneralMaster.SETRANGE(Disable, FALSE);
        GeneralMaster.SETCURRENTKEY("Sequence No.");
        IF GeneralMaster.FINDFIRST THEN BEGIN
            LoanProcTrackingRec.RESET;
            LoanProcTrackingRec.SETRANGE("Application No.", VehicleFinanceAppHeader."Application No.");
            IF LoanProcTrackingRec.FINDLAST THEN
                lineno := LoanProcTrackingRec."Line No." + 10000;
            REPEAT
                LoanProcTrackingRec.RESET;
                LoanProcTrackingRec.SETRANGE("Application No.", VehicleFinanceAppHeader."Application No.");
                LoanProcTrackingRec.SETRANGE(Components, GeneralMaster.Code);
                IF NOT LoanProcTrackingRec.FINDFIRST THEN BEGIN
                    LoanProcTrackingRec.INIT;
                    LoanProcTrackingRec."Application No." := VehicleFinanceAppHeader."Application No.";
                    LoanProcTrackingRec."Line No." := lineno;
                    LoanProcTrackingRec.Components := GeneralMaster.Code;
                    LoanProcTrackingRec."Components Description" := GeneralMaster.Description;
                    IF LoanProcTrackingRec."Line No." = 10000 THEN BEGIN
                        LoanProcTrackingRec.Processed := TRUE;
                        LoanProcTrackingRec."Processing Time" := 0;
                        LoanProcTrackingRec.Date := TODAY;
                        LoanProcTrackingRec."User Id" := USERID;
                    END;
                    LoanProcTrackingRec.INSERT;
                    lineno := lineno + 10000;
                END;
            UNTIL GeneralMaster.NEXT = 0;
        END;
        //SRT Dec 5th 2019 <<
    end;
}

