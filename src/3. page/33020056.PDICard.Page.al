page 33020056 "PDI Card"
{
    PageType = Card;
    SourceTable = Table33019851;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Customer No."; "Customer No.")
                {
                }
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field("Invoice No."; "Invoice No.")
                {
                }
                field("Sales Date"; "Sales Date")
                {
                }
                field("PDI Date"; "PDI Date")
                {
                }
                field(Make; Make)
                {
                }
                field(Model; Model)
                {
                }
                field("Registration No."; "Registration No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Engine No."; "Engine No.")
                {
                }
                field(Color; Color)
                {
                }
                field(Kilometrage; Kilometrage)
                {
                }
                field("Key No."; "Key No.")
                {
                }
                field("Source ID"; "Source ID")
                {
                    Visible = false;
                }
                field("PDI Type"; "PDI Type")
                {
                }
                field("Accountability Center"; "Accountability Center")
                {
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                }
            }
            part("PDI Requistion Sheet"; 33020057)
            {
                SubPageLink = PDI No.=FIELD(No.);
            }
            group(Specifications)
            {
                Caption = 'Specifications';
                Visible = SpecificationVehicle;
                field("F.L No."; "Tyre F.L No.")
                {
                }
                field("F.R No."; "Tyre F.R No.")
                {
                }
                field("R.L No."; "Tyre R.L No.")
                {
                }
                field("R.R. No."; "Tyre R.R. No.")
                {
                }
                field("Spare No."; "Tyre Spare No.")
                {
                }
                field("F.L Size"; "Tyre F.L Size")
                {
                }
                field("F.R Size"; "Tyre F.R Size")
                {
                }
                field("R.L Size"; "Tyre R.L Size")
                {
                }
                field("R.R. Size"; "Tyre R.R. Size")
                {
                }
                field("Spare Size"; "Tyre Spare Size")
                {
                }
                field("F.L Make"; "Tyre F.L Make")
                {
                }
                field("F.R Make"; "Tyre F.R Make")
                {
                }
                field("R.L Make"; "Tyre R.L Make")
                {
                }
                field("R.R. Make"; "Tyre R.R. Make")
                {
                }
                field("Spare Make"; "Tyre Spare Make")
                {
                }
                field("F.I Pump No."; "F.I Pump No.")
                {
                }
                field("F.I Pump Make"; "F.I Pump Make")
                {
                }
                field("Speedometer Make"; "Speedometer Make")
                {
                }
                field("Battery No."; "Battery No.")
                {
                }
                field("Battery Make"; "Battery Make")
                {
                }
                field("Starter Motor Make"; "Starter Motor Make")
                {
                }
                field("Radiator Make"; "Radiator Make")
                {
                }
                field("Alternator Make"; "Alternator Make")
                {
                }
                field("S.L No."; "S.L No.")
                {
                }
                field("G.B No."; "G.B No.")
                {
                }
                field("F.A No."; "F.A No.")
                {
                }
                field("T.C No."; "T.C No.")
                {
                }
                field("R.A No."; "R.A No.")
                {
                }
                field("Mobile No."; "Mobile No.")
                {
                }
                field(Status; Status)
                {
                }
                field("Closed Date"; "Closed Date")
                {
                }
                field("Turbo Charger Serial No."; "Turbo Charger Serial No.")
                {
                }
                field("Motor Serial No."; "Motor Serial No.")
                {
                    Visible = IsMElectric;
                }
                field("RF ID Code"; "RF ID Code")
                {
                    Visible = IsMElectric;
                }
                field("Type 1 Charger Serial No."; "Type 1 Charger Serial No.")
                {
                    Visible = IsMElectric;
                }
                field("Type 2 Charger Serial No."; "Type 2 Charger Serial No.")
                {
                    Visible = IsMElectric;
                }
                field("Motor Identification No."; "Motor Identification No.")
                {
                    Visible = IsThreeWheeler;
                }
                field("Battery Pack Serial No."; "Battery Pack Serial No.")
                {
                    Visible = IsThreeWheeler;
                }
                field("Telematics Number"; "Telematics Number")
                {
                    Visible = IsThreeWheeler;
                }
            }
            group("Tractor Specifications")
            {
                Caption = 'Tractor Specifications';
                Visible = SpecificationTractor;
                field("Injection Pump Make"; "Injection Pump Make")
                {
                }
                field("Injection Serial No."; "Injection Serial No.")
                {
                }
                field("Starter Motor Make "; "Starter Motor Make")
                {
                }
                field("Starter Serial No."; "Starter Serial No.")
                {
                }
                field("Alternator Make 4"; "Alternator Make")
                {
                }
                field("Alternator Serial No."; "Alternator Serial No.")
                {
                }
                field("Front Tyre Make"; "Front Tyre Make")
                {
                }
                field("Front Tyre Size"; "Front Tyre Size")
                {
                }
                field("F. LH side tyre serial no."; "F. LH side tyre serial no.")
                {
                }
                field("F. RH side tyre serial no."; "F. RH side tyre serial no.")
                {
                }
                field("Rear Tyre Make"; "Rear Tyre Make")
                {
                }
                field("Rear Tyre Size"; "Rear Tyre Size")
                {
                }
                field("R. LH side tyre serial no."; "R. LH side tyre serial no.")
                {
                }
                field("R. RH side tyre serial no."; "R. RH side tyre serial no.")
                {
                }
                field("Battery Make "; "Battery Make")
                {
                }
                field("Battery Type"; "Battery Type")
                {
                }
                field("Battery Sr. No."; "Battery Sr. No.")
                {
                }
                field("Turbo Charger Serial No. "; "Turbo Charger Serial No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000048>")
            {
                Caption = 'Close PDI';

                trigger OnAction()
                begin
                    IF CONFIRM(ClosePDIWithReason, FALSE, "Registration No.", VIN) THEN BEGIN
                        Status := Status::Closed;
                        "Closed Date" := CURRENTDATETIME;
                    END;
                end;
            }
        }
        area(creation)
        {
            action("<Action1000000056>")
            {
                Caption = '&PDI Estimation';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(PDIHdr);
                    REPORT.RUNMODAL(33020022, TRUE, FALSE, PDIHdr);
                end;
            }
            action("&Insurance Claim")
            {
                Caption = '&Insurance Claim';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //CurrPage.SETSELECTIONFILTER(PDIHdr);
                    REPORT.RUNMODAL(33020028, TRUE, FALSE, PDIHdr);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        /*
        IF Status = Status ::Closed THEN
        CurrPage.EDITABLE := FALSE;
        */
        IF Make = 'M&M-FE' THEN BEGIN
            SpecificationTractor := TRUE;
            SpecificationVehicle := FALSE;
        END ELSE BEGIN
            SpecificationTractor := FALSE;
            SpecificationVehicle := TRUE;
        END;

        //ronij jan 16 2025
        IsMElectric := FALSE;
        IsThreeWheeler := FALSE;
        IF Make = 'M-ELECTRIC' THEN
            IsMElectric := TRUE;

        IF Make = '3WHEELERS' THEN
            IsThreeWheeler := TRUE;

    end;

    var
        ClosePDIWithReason: Label 'Do you want to close this complain for vehicle with Registration No : %1, VIN : %2 ?';
        PDIHdr: Record "33019851";
        [InDataSet]
        SpecificationTractor: Boolean;
        [InDataSet]
        SpecificationVehicle: Boolean;
        IsMElectric: Boolean;
        IsThreeWheeler: Boolean;
}

