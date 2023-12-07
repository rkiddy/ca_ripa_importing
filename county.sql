drop table if exists ripa_summaries_XXX;

create table ripa_summaries_XXX (
    pk int primary key,
    file_pk int,
    PERSON_NUMBER int,
    AGENCY_ORI char(9),
    AGENCY_NAME varchar(127),
    TIME_OF_STOP char(8),
    DATE_OF_STOP date,
    YEAR_OF_STOP int,
    RAE_FULL tinyint,
    G_FULL tinyint,
    AGE int,
    LIMITED_ENGLISH_FLUENCY tinyint,
    PD_FULL tinyint);

alter table ripa_summaries_XXX add index(AGENCY_NAME);
alter table ripa_summaries_XXX add index(YEAR_OF_STOP);
alter table ripa_summaries_XXX add index(RAE_FULL);
alter table ripa_summaries_XXX add index(G_FULL);
alter table ripa_summaries_XXX add index(AGE);
alter table ripa_summaries_XXX add index(PD_FULL);

insert into ripa_summaries_XXX
select pk,
       file_pk,
       PERSON_NUMBER,
       AGENCY_ORI,
       AGENCY_NAME,
       TIME_OF_STOP,
       DATE_OF_STOP,
       substr(DATE_OF_STOP, 1, 4),
       RAE_FULL,
       G_FULL,
       AGE,
       LIMITED_ENGLISH_FLUENCY,
       PD_FULL
from ripa_YYY
where substr(AGENCY_ORI,3,3) = 'XXX';
