codeunit 33020142 "Vehicle Sales CRM  Management"
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure ShowKAPDetails(PrmSalespersonCode: Code[20]; PrmYear: Integer; PrmMonth: Integer; PrmWeek: Integer)
    var
        lclKAPDetails: Record "33020200";
        lclKAPDetails2: Record "33020200";
        lclKAPDetailsPage: Page "33020206";
    begin
        //Open the page with filter.
        lclKAPDetails.RESET;
        lclKAPDetails.SETRANGE("Salesperson Code", PrmSalespersonCode);
        lclKAPDetails.SETRANGE(Year, PrmYear);
        lclKAPDetails.SETRANGE(Month, PrmMonth);
        lclKAPDetails.SETRANGE("Week No", PrmWeek);
        lclKAPDetailsPage.SETTABLEVIEW(lclKAPDetails);
        lclKAPDetailsPage.RUNMODAL;
    end;

    [Scope('Internal')]
    procedure "-------------------CNY.CRM----"()
    begin
    end;

    [Scope('Internal')]
    procedure ChangePipelineStatus(NewPipeline_P: Code[10]; NewDate_P: Date; PipelineMangDetails_P: Record "33020141"; OrderNo: Code[20])
    var
        PipelineMangDetails_L: Record "33020141";
    begin
        //Changing the pipeline code of prospect.

        PipelineMangDetails_L.RESET;
        PipelineMangDetails_L.SETRANGE("Prospect No.", PipelineMangDetails_P."Prospect No.");
        PipelineMangDetails_L.SETRANGE("Line No.", PipelineMangDetails_P."Line No.");
        IF PipelineMangDetails_L.FINDFIRST THEN BEGIN
            PipelineMangDetails_L."Pipeline Code" := NewPipeline_P;
            PipelineMangDetails_L."Last Modified Date" := NewDate_P;
            IF PipelineMangDetails_L."Pipeline Code" <> 'C0' THEN
                PipelineMangDetails_L."Sales Order No." := OrderNo;
            IF NewPipeline_P = 'C3' THEN BEGIN
                PipelineMangDetails_L."Pipeline Status" := PipelineMangDetails_L."Pipeline Status"::Closed;
                PipelineMangDetails_L."Sales Invoice No." := OrderNo;
            END;
            //IF NewPipeline_P = 'C3' THEN
            //PipelineMangDetails_L."Pipeline Status" := PipelineMangDetails_L."Pipeline Status" :: Closed;

            PipelineMangDetails_L.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure InsertProsPipelineHistory(NewPipeline_P: Code[10]; NewDate_P: Date; var PipelineMangDetails_P: Record "33020141")
    var
        ProsPlHsty_L: Record "33020198";
    begin
        //Inserting Pipeline changes for Prospect.

        ProsPlHsty_L.INIT;
        ProsPlHsty_L."Prospect No." := PipelineMangDetails_P."Prospect No.";
        ProsPlHsty_L."Prospect Line No" := PipelineMangDetails_P."Line No.";
        ProsPlHsty_L."Old Pipeline Code" := PipelineMangDetails_P."Pipeline Code";
        ProsPlHsty_L."New Pipeline Code" := NewPipeline_P;
        ProsPlHsty_L."New Date" := NewDate_P;
        ProsPlHsty_L."SalesPerson Code" := PipelineMangDetails_P."Salesperson Code";
        ProsPlHsty_L."Old Date" := PipelineMangDetails_P."Last Modified Date";
        ProsPlHsty_L."Make Code" := PipelineMangDetails_P."Make Code";
        ProsPlHsty_L."Model Code" := PipelineMangDetails_P."Model Code";
        ProsPlHsty_L."Model Version No." := PipelineMangDetails_P."Model Version No.";
        ProsPlHsty_L.INSERT;
    end;
}

