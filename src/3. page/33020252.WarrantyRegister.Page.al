page 33020252 "Warranty Register"
{
    Editable = true;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table33020249;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
                field("Service Order No."; "Service Order No.")
                {
                    Editable = false;
                }
                field("Sell to Customer No."; "Sell to Customer No.")
                {
                    Editable = false;
                }
                field("Bill to Customer No."; "Bill to Customer No.")
                {
                    Editable = false;
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    Visible = false;
                }
                field("Accountability Center"; "Accountability Center")
                {
                    Editable = false;
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Prowac Year"; "Prowac Year")
                {
                    Editable = false;
                }
                field(VIN; VIN)
                {
                }
                field("Claim/Ref No."; "Claim/Ref No.")
                {
                    Editable = true;
                }
                field("Claim Status"; "Claim Status")
                {
                    Editable = true;
                }
                field("Claimed Date"; "Claimed Date")
                {
                }
                field(Hide; Hide)
                {
                    Visible = false;
                }
                field("Hidden Reason"; "Hidden Reason")
                {
                    Visible = false;
                }
            }
            part(; 33020253)
            {
                SubPageLink = No.=FIELD(No.),
                              Prowac Year=FIELD(Prowac Year);
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
            action("E&xport Warranty")
            {
                Caption = 'E&xport Warranty';
                Visible = false;

                trigger OnAction()
                var
                    ExportWarr: XMLport "50008";
                begin
                    WarrantyReg.RESET;
                    WarrantyReg.SETRANGE("No.","No.");
                    WarrantyReg.SETRANGE("Prowac Year","Prowac Year");
                    WarrantyReg.SETRANGE(Export,TRUE);
                    ExportWarr.SETTABLEVIEW(WarrantyReg);
                    ExportWarr.RUN;
                end;
            }
            action("<Action1000000005>")
            {
                Caption = 'Claim Warranty';
                Image = Click;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TESTFIELD("Claim/Ref No.");
                    "Claim Status" := TRUE;
                    MODIFY;
                end;
            }
        }
    }

    var
        WarrantyReg: Record "33020238";
}

