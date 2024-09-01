create database hospital;
use hospital;

ALTER TABLE appointments ADD PRIMARY KEY (appointment_id);
ALTER TABLE doctors ADD PRIMARY KEY (doctor_id);
ALTER TABLE patients ADD PRIMARY KEY (patient_id);

ALTER TABLE appointments ADD CONSTRAINT fk_doctor_id FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id);
ALTER TABLE appointments ADD CONSTRAINT fk_patient_id FOREIGN KEY (patient_id) REFERENCES patients(patient_id);


select * from appointments;
select* from doctors;
select * from patients;

-- How many appointments are there in total.

select count(*) as total_appointments
from appointments;

-- 1. Count the no. of Doctors in each specilaization.

select count(*) as "Doctors_count", specialization 
from doctors 
group by specialization;

-- 2. Find no. of Appointments per Doctor. 

select d.doctor_id, concat(d.first_name, ' ', d.last_name) as "FullName" , count(appointment_id) as Total_Appointments
from doctors as d 
join appointments as a
on d.doctor_id= a.doctor_id
group by d.doctor_id, FullName
order by Total_Appointments desc;

-- 3. List out common reasons for Appointments.

select reason, count(*) as "Total_Appointments"
from appointments
group by reason
order by "Total_Appointments" desc;

-- 4. Count the Total no. of Patients by gender  . 

select gender , count(*) as "Total_Patients"
from patients 
group by gender;

-- 5. Find total no. of Patients in each age group.

select case
when YEAR(CURDATE()) - YEAR(STR_TO_DATE(date_of_birth, '%m/%d/%Y')) < 18 then 'Under 18'
when YEAR(CURDATE()) - YEAR(STR_TO_DATE(date_of_birth, '%m/%d/%Y')) BETWEEN 18 AND 35 then '18-35'
when YEAR(CURDATE()) - YEAR(STR_TO_DATE(date_of_birth, '%m/%d/%Y')) BETWEEN 36 AND 50 then '36-50'
when YEAR(CURDATE()) - YEAR(STR_TO_DATE(date_of_birth, '%m/%d/%Y')) BETWEEN 51 AND 65 then '51-65'
else'Above 65'
end as age_groups,
COUNT(*) as total_patients
FROM patients
GROUP BY age_groups
order by total_patients asc;

-- 6. Retrieve list of top 10 Patients with most number visits.

select p.patient_id, concat(p.first_name, ' ', p.last_name) as "Full_Name" , 
count(a.appointment_id) as visit_count
from patients as p 
join appointments as a
on p.patient_id = a.patient_id
group by p.patient_id, Full_Name
order by visit_count desc
LIMIT 10;

-- 7. What are most frequent Specialization for Appointments.

select d.specialization, count(appointment_id) as "total_appointments"
from doctors as d 
join appointments as a 
on d.doctor_id= a.doctor_id 
group by d.specialization
order by total_appointments desc;

-- 8. Details of Patients who have more than one Appointments .

select p.patient_id, concat(p.first_name, ' ', p.last_name) as "PatientName", count(a.appointment_date) as "Total_aapointments"
from patients as p 
join appointments as a 
on a.patient_id= p.patient_id
group by p.patient_id 
having count(a.appointment_id) > 1 
order by "Total_appointments";

-- 9. How many Patients visits the same Doctor.

select p.patient_id,  concat(p.first_name, ' ', p.last_name) as "PatientName",
concat(d.first_name, ' ', d.last_name) as "DoctorName", count(*) as "visit_count"
from appointments as a
join patients as p ON a.patient_id= p.patient_id 
join doctors as d ON a.doctor_id= d.doctor_id
group by p.patient_id, d.doctor_id
order by visit_count desc;

-- 10. How many doctors have appointments in month "2024-01".
 
select d.doctor_id, concat(d.first_name, ' ', d.last_name) as "DoctorName"
from doctors d
where d.doctor_id in (
    select a.doctor_id
    from appointments a
    where DATE_FORMAT(STR_TO_DATE(a.appointment_date, '%m/%d/%Y %H:%i'), '%Y-%m') = '2024-01'
);













