page 33020248 "Warranty Register List"
{
    CardPageID = "Warranty Register";
    Editable = false;
    PageType = List;
    SourceTable = Table33020249;
    SourceTableView = SORTING(Job Close Date)
                      ORDER(Ascending)
                      WHERE(No.=FILTER(<>''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field("Service Order No.";"Service Order No.")
                {
                }
                field("Sell to Customer No.";"Sell to Customer No.")
                {
                }
                field("Sell to Customer Name";"Sell to Customer Name")
                {
                }
                field("Bill to Customer No.";"Bill to Customer No.")
                {
                }
                field("Bill to Customer Name";"Bill to Customer Name")
                {
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    Visible = false;
                }
                field("Accountability Center";"Accountability Center")
                {
                }
                field("Make Code";"Make Code")
                {
                }
                field("Model Code";"Model Code")
                {
                }
                field("Model Version No.";"Model Version No.")
                {
                }
                field("Vehicle Registration No.";"Vehicle Registration No.")
                {
                }
                field(VIN;VIN)
                {
                }
                field("Engine No.";"Engine No.")
                {
                }
                field("Location Code";"Location Code")
                {
                }
                field(Exported;Exported)
                {
                }
                field("Prowac Year";"Prowac Year")
                {
                }
                field("Job Close Date";"Job Close Date")
                {
                }
                field(Hide;Hide)
                {
                    Visible = false;
                }
                field("Hidden Reason";"Hidden Reason")
                {
                    Visible = false;
                }
                field("Claim/Ref No.";"Claim/Ref No.")
                {
                    Editable = false;
                }
                field("Claim Status";"Claim Status")
                {
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(;Notes)
            {
            }
            systempart(;Links)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Export Warranty")
            {
                Caption = '&Export Warranty';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    WarrantyLine: Record "33020249";
                begin
                    SetRecSelectionFilter(WarrantyLine);
                end;
            }
        }
    }

    var
        GlobalWarrantyLine: Record "33020249";
        WarrantyReg: Record "33020238";
        ExportWarr: XMLport "50008";
                        GlobalWarrantyReg: Record "33020238";
                        GlobalWarrantyReg2: Record "33020238";

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        UserProfileSetup: Record "25006067";
        UserSetup: Record "91";
    begin
        /*FILTERGROUP(2);
        IF UserSetup.GET(USERID) THEN BEGIN
          if UserProfileSetup.get(UserSetup."Default User Profile Code") then
        
        END;
        FILTERGROUP(0);
        */

    end;

    [Scope('Internal')]
    procedure SetRecSelectionFilter(var WarrantyLine: Record "33020249")
    begin
        CurrPage.SETSELECTIONFILTER(WarrantyLine);
        SetWarrantyLineSelection(WarrantyLine);
        ExportWarr.SETTABLEVIEW(GlobalWarrantyReg2);
        ExportWarr.RUN;
    end;

    [Scope('Internal')]
    procedure SetWarrantyLineSelection(var WarrantyLine: Record "33020249")
    begin
        GlobalWarrantyReg2.RESET;
        IF WarrantyLine.FINDFIRST THEN
            REPEAT
                GlobalWarrantyReg.RESET;
                GlobalWarrantyReg.SETRANGE("No.", WarrantyLine."No.");
                GlobalWarrantyReg.SETRANGE("Prowac Year", WarrantyLine."Prowac Year");
                GlobalWarrantyReg.SETRANGE(Export, TRUE);
                IF GlobalWarrantyReg.FINDSET THEN BEGIN
                    REPEAT
                        GlobalWarrantyReg2 := GlobalWarrantyReg;
                        GlobalWarrantyReg2.MARK(TRUE);
                    UNTIL GlobalWarrantyReg.NEXT = 0;
                END;
            UNTIL WarrantyLine.NEXT = 0;
        GlobalWarrantyReg2.MARKEDONLY(TRUE);
    end;
}

