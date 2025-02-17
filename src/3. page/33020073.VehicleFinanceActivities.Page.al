page 33020073 "Vehicle Finance Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = Table33020070;

    layout
    {
        area(content)
        {
            cuegroup("Loan Files")
            {
                Caption = 'Loan Files';
                field(Applications; Applications)
                {
                    Caption = 'Applications';
                    DrillDown = true;
                    DrillDownPageID = "Vehicle Finance List";
                }
                field("Approved Loan File"; "Approved Loan File")
                {
                    Caption = 'Approved Files';
                    DrillDownPageID = "Approved Vehicle Finance List";
                }
                field("Disbursed Loan"; "Disbursed Loan")
                {
                    DrillDownPageID = "Approved Vehicle Finance List";
                }
                field("Closed Loan File"; "Closed Loan File")
                {
                    Caption = 'Closed Files';
                    DrillDownPageID = "Approved Vehicle Finance List";
                }
                field(Defaulter; Defaulter)
                {
                    DrillDownPageID = "Approved Vehicle Finance List";
                }
                field(Captured; Captured)
                {
                    DrillDownPageID = "Approved Vehicle Finance List";
                }
                field("Rejected Applications"; "Rejected Applications")
                {
                    DrillDownPageID = "Vehicle Finance List";
                }
                field("Rejected Loan"; "Rejected Loan")
                {
                    DrillDownPageID = "Approved Vehicle Finance List";
                }

                actions
                {
                    action("Edit Cash Receipt Journal")
                    {
                        Caption = 'Edit Cash Receipt Journal';
                        RunObject = Page 255;
                    }
                    action("<Action3>")
                    {
                        Caption = 'Bank Accounts';
                        RunObject = Page 370;
                        RunPageMode = View;
                    }
                    action("<Action4>")
                    {
                        Caption = 'Customers';
                        RunObject = Page 21;
                        RunPageMode = View;
                    }
                }
            }
            cuegroup("Vehicle Insurance")
            {
                Caption = 'Vehicle Insurance';
                field("Insurance Expiring On 10 Days"; "Insurance Expiring On 10 Days")
                {

                    trigger OnDrillDown()
                    begin
                        VehicleInsMgt2.DrillExpiringIns(10);
                    end;
                }
                field("Insurance Expired"; "Insurance Expired")
                {

                    trigger OnDrillDown()
                    begin
                        VehicleInsMgt2.DrillExpiredIns;
                    end;
                }
                field("Pending Approval Ins. List"; "Pending Approval Ins. List")
                {
                    DrillDownPageID = "Pending Approval Veh. Ins. Lst";
                    LookupPageID = "Pending Approval Veh. Ins. Lst";
                }
                field("Approved Insurance List"; "Approved Insurance List")
                {
                    DrillDownPageID = "Approved Veh. Insurance List";
                    LookupPageID = "Approved Veh. Insurance List";
                }
            }
            cuegroup("NPA Status")
            {
                Caption = 'NPA Status';
                field(Performing; Performing)
                {
                    DrillDownPageID = "Approved Vehicle Finance List";
                }
                field(Substandard; Substandard)
                {
                    DrillDownPageID = "Approved Vehicle Finance List";
                }
                field(Doubtful; Doubtful)
                {
                    DrillDownPageID = "Approved Vehicle Finance List";
                }
                field(Critical; Critical)
                {
                    DrillDownPageID = "Approved Vehicle Finance List";
                }
            }
            cuegroup("Follow Up")
            {
                Caption = 'Follow Up';
                field("Today's Follow Up"; "Today's Follow Up")
                {
                    DrillDownPageID = "Vehicle Finance FU Register";
                }
                field("Missed Follow Up"; "Missed Follow Up")
                {
                    DrillDownPageID = "Vehicle Finance FU Register";
                }
            }
            cuegroup("Dues as of Day")
            {
                field("Total Due"; "Total Due")
                {
                    DrillDownPageID = "Approved Vehicle Finance List";
                }
                field("Principal Due"; "Principal Due")
                {
                    DrillDownPageID = "Approved Vehicle Finance List";
                }
                field("Interest Due"; "Interest Due")
                {
                    DrillDownPageID = "Approved Vehicle Finance List";
                }
                field("Penalty Due"; "Penalty Due")
                {
                    DrillDownPageID = "Approved Vehicle Finance List";
                }
                field("Insurrance Due"; GetInsurrancerDue)
                {

                    trigger OnDrillDown()
                    begin
                        PAGE.RUN(PAGE::"Approved Vehicle Finance List", VFHeader2);
                    end;
                }
                field("Other Due"; GetOtherDue)
                {

                    trigger OnDrillDown()
                    begin
                        PAGE.RUN(PAGE::"Approved Vehicle Finance List", VFHeader);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //CalcVehInsExpirationCount;
    end;

    trigger OnOpenPage()
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;
        SETFILTER(Datefilter, '%1', TODAY);
        SETFILTER("Missed Datefilter", '<%1', TODAY);
        UserSetup.GET(USERID);
        IF UserSetup."Salespers./Purch. Code" <> '' THEN BEGIN
            SETRANGE("Salesperson Code", UserSetup."Salespers./Purch. Code");
        END;

        //NPA %
        CALCFIELDS("Substandard Outstanding", "Doubtful Outstanding", "Critical Outstanding", "Total Loan");
        IF "Total Loan" <> 0 THEN BEGIN
            "Substandard %" := ROUND(("Substandard Outstanding" / "Total Loan") * 100, 0.01, '=');
            "Doubtful %" := ROUND(("Doubtful Outstanding" / "Total Loan") * 100, 0.01, '=');
            "Critical %" := ROUND(("Critical Outstanding" / "Total Loan") * 100, 0.01, '=');
        END;
        MODIFY;
    end;

    var
        UserSetup: Record "91";
        UserMgt: Codeunit "5700";
        VehicleInsMgt2: Codeunit "25006200";
        VFHeader: Record "33020062";
        VFHeader2: Record "33020062";

    [Scope('Internal')]
    procedure CalcVehInsExpirationCount()
    begin
        //IF FIELDACTIVE("Insurance Expiring On 7 Days") THEN
        //  "Insurance Expiring On 7 Days" := ActivitiesMgt.CalcOverdueSalesInvoiceAmount;

        IF FIELDACTIVE("Insurance Expiring On 10 Days") THEN BEGIN
            "Insurance Expiring On 10 Days" := VehicleInsMgt2.CalcExpiringIns(10);
        END;
        IF FIELDACTIVE("Insurance Expired") THEN BEGIN
            "Insurance Expired" := VehicleInsMgt2.CalcExpiredIns;       //ZM June 28, 2018
        END;
    end;

    local procedure GetOtherDue(): Decimal
    var
        OtherDueAmt: Decimal;
    begin
        OtherDueAmt := 0;
        VFHeader.RESET;
        VFHeader.SETRANGE(Closed, FALSE);
        VFHeader.SETRANGE("Loan Disbursed", TRUE);
        VFHeader.SETRANGE(Rejected, FALSE);
        VFHeader.CALCFIELDS("Other Amount Due");
        VFHeader.SETFILTER("Other Amount Due", '>%1', 0);
        IF VFHeader.FINDSET THEN
            REPEAT
                VFHeader.CALCFIELDS("Other Amount Due");
                OtherDueAmt += VFHeader."Other Amount Due";
            UNTIL VFHeader.NEXT = 0;

        EXIT(OtherDueAmt);
    end;

    local procedure GetInsurrancerDue(): Decimal
    var
        OtherDueAmt: Decimal;
    begin
        OtherDueAmt := 0;
        VFHeader2.RESET;
        VFHeader2.SETRANGE(Closed, FALSE);
        VFHeader2.SETRANGE("Loan Disbursed", TRUE);
        VFHeader2.SETRANGE(Rejected, FALSE);
        VFHeader2.CALCFIELDS("Insurance Due");
        VFHeader2.SETFILTER("Insurance Due", '>%1', 0);
        IF VFHeader2.FINDSET THEN
            REPEAT
                VFHeader2.CALCFIELDS("Insurance Due");
                OtherDueAmt += VFHeader2."Insurance Due";
            UNTIL VFHeader2.NEXT = 0;

        EXIT(OtherDueAmt);
    end;
}

