
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Для нового объекта выполняем код инициализации формы в ПриСозданииНаСервере.
	// Для существующего - в ПриЧтенииНаСервере.
	Ссылка = Объект.Ссылка;
	Если Ссылка.Пустая() Тогда
		ИнициализироватьФормуЗадачи();
	КонецЕсли;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
			
	Если Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидВычета();
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
		ПараметрыГиперссылки = МодульРаботаСФайлами.ГиперссылкаФайлов();
		ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
		ПараметрыГиперссылки.Владелец = "Объект.БизнесПроцесс";
		МодульРаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	БизнесПроцессыИЗадачиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтотОбъект);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	БизнесПроцессыЗаявокСотрудниковФормы.ЗаписатьРеквизитыБизнесПроцесса(ЭтотОбъект, ТекущийОбъект);
	
	ВыполнитьЗадачу = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыЗаписи, "ВыполнитьЗадачу", Ложь);
	Если НЕ ВыполнитьЗадачу Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗаданиеВыполнено И НЕ ЗначениеЗаполнено(ТекущийОбъект.РезультатВыполнения) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Укажите причину, по которой задача отклоняется.';
				|en = 'Please tell why you decline the task.'"),,
			"Объект.РезультатВыполнения",,
			Отказ);
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	БизнесПроцессыИЗадачиКлиент.ФормаЗадачиОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	Если ИмяСобытия = "Запись_Задание" Тогда
		Если (Источник = Объект.БизнесПроцесс ИЛИ (ТипЗнч(Источник) = Тип("Массив") 
			И Источник.Найти(Объект.БизнесПроцесс) <> Неопределено)) Тогда
			Прочитать();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ЗаявкиСотрудниковЗаписанДокумент" Тогда
		Если (Источник = ЭтотОбъект) Тогда
			ЗаписанДокументНалоговыйВычет(Параметр);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ШаблонОтветаЗаписанСправочник" Тогда
		Если (Источник = ЭтотОбъект) Тогда
			ШаблонОтвета = Параметр;
			Элементы.ШаблонОтвета.Видимость = Истина;
			ШаблонОтветаПриИзмененииНаСервере();
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИнициализироватьФормуЗадачи();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект);	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеФайлаОтветаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПрисоединенныйФайл(ФайлОтвета);	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайлНажатие(Элемент)
	УдалитьПрисоединенныйФайл();	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФайлНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПрисоединенныйФайл(ЭтотОбъект[Элемент.Имя]);	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеЗаявлениеНаВычетПриИзменении(Элемент)
	ЗаписанДокументНалоговыйВычет(Задание.ЗаявлениеНаВычет);
КонецПроцедуры

&НаКлиенте
Процедура ШаблонОтветаПриИзменении(Элемент)
	ШаблонОтветаПриИзмененииНаСервере();	
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,
			ПараметрыПеретаскивания, СтандартнаяОбработка);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент,
			ПараметрыПеретаскивания, СтандартнаяОбработка);
	КонецЕсли;	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполненоВыполнить(Команда)
	Если ПодписыватьЗаявкиСотрудника Тогда
		БизнесПроцессыЗаявокСотрудниковКлиент.ПодписатьЗаявкуЭП(ЭтотОбъект, "ВыполненоВыполнитьЗавершение");
	Иначе
		ВыполненоВыполнитьЗавершение(Неопределено, Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отказать(Команда)
	
	Отказ = Ложь;
	ОтказатьНаСервере(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	Если ПодписыватьЗаявкиСотрудника Тогда
		БизнесПроцессыЗаявокСотрудниковКлиент.ПодписатьЗаявкуЭП(ЭтотОбъект, "ОтказатьЗавершение");
	Иначе
		ОтказатьЗавершение(Неопределено, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокумент(Команда)
	ПараметрыФормыДокумента = ПараметрыФормыДокумента();
	НаименованиеФормы = ПараметрыФормыДокумента.НаименованиеФормы;
	Если НаименованиеФормы <> "" Тогда
		ОткрытьФорму(НаименованиеФормы, ПараметрыФормыДокумента.ПараметрыЗаполнения, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписанДокументНалоговыйВычет(Результат)
	
	ЗаявлениеНаВычет = Неопределено;
	Если Результат <> Неопределено Тогда
		ЗаявлениеНаВычет = Результат;
	КонецЕсли;
	
	ЗаписанДокументНалоговыйВычетНаСервере(ЗаявлениеНаВычет);
	УстановитьВидимостьКнопокДействий();
			
КонецПроцедуры

&НаКлиенте
Процедура Дополнительно(Команда)
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	БизнесПроцессыЗаявокСотрудниковКлиент.ПринятьЗадачуКИсполнению(ЭтотОбъект, ТекущийПользователь);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	БизнесПроцессыИЗадачиКлиент.ОтменитьПринятиеЗадачКИсполнению(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Ссылка));
	Прочитать();
	БизнесПроцессыИЗадачиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЗадание(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;	
	ПоказатьЗначение(,Объект.БизнесПроцесс);	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлОтвета(Команда)
	
	Обработчик = Новый ОписаниеОповещения("ВыбратьФайлОтветаПослеПомещенияФайла", ЭтотОбъект);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Файлы MS Word (*.doc;*.docx)|*.doc;*.docx|Файлы PDF(*.pdf;*.PDF)|*.pdf;*.PDF';
											|en = 'MS Word files (*.doc;*.docx)|*.doc;*.docx|PDF files (*.pdf;*.PDF)|*.pdf;*.PDF'");

	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;

	ФайловаяСистемаКлиент.ЗагрузитьФайл(Обработчик, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьШаблонОтвета(Команда)
	БизнесПроцессыЗаявокСотрудниковКлиент.СохранитьШаблонОтвета(ЭтотОбъект);
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
	КонецЕсли;	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СерверныеОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ШаблонОтветаПриИзмененииНаСервере()
	БизнесПроцессыЗаявокСотрудниковФормы.ПослеВыбораШаблона(ЭтотОбъект, ШаблонОтвета, Неопределено);
КонецПроцедуры

#КонецОбласти

#Область СерверныеОбработчикиКомандФормы

&НаСервере
Процедура ОтказатьНаСервере(Отказ)
	Если ПустаяСтрока(Задание.ОтветПоЗаявке)
		 И КабинетСотрудника.ИспользоватьФормат302() Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не заполнена причина отказа.';
													|en = 'The refusal reason is not filled in.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаписанДокументНалоговыйВычетНаСервере(ЗаявлениеНаВычет)
	ЗаданиеОбъект = РеквизитФормыВЗначение("Задание");
	ЗаданиеОбъект.ЗаявлениеНаВычет = ЗаявлениеНаВычет;
	ЗаданиеОбъект.Записать();
	ЗначениеВРеквизитФормы(ЗаданиеОбъект, "Задание");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОповещения

&НаКлиенте
Процедура ВыбратьФайлОтветаПослеПомещенияФайла(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	БизнесПроцессыЗаявокСотрудниковКлиент.ВыбратьФайлОтветаПослеПомещенияФайла(ЭтотОбъект,
																			   ПомещенныйФайл,
																			   ДополнительныеПараметры);																		   
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполненоВыполнитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	БизнесПроцессыЗаявокСотрудниковКлиент.ВыполненоВыполнитьЗавершение(ЭтотОбъект, Результат, ДополнительныеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ОтказатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	БизнесПроцессыЗаявокСотрудниковКлиент.ОтказатьЗавершение(ЭтотОбъект, Результат, ДополнительныеПараметры);
КонецПроцедуры	

#КонецОбласти

#Область ОткрытиеФормДокументов

&НаСервере
Функция ПараметрыФормыДокумента()
	
	ПараметрыФормыДокумента = Новый Структура("НаименованиеФормы, ПараметрыЗаполнения");
	
	ПараметрыЗаполнения = Новый Структура;
	НаименованиеФормы = "";
	Если Задание.ЛичныйВычет ИЛИ Задание.ВычетНаДетей Тогда
		ЗаполнитьПараметрыЗаполненияЛичныйВычет(ПараметрыЗаполнения);
		НаименованиеФормы = "Документ.ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛ.ФормаОбъекта";
	Иначе
		ЗаполнитьПараметрыЗаполненияВычет(ПараметрыЗаполнения);
		НаименованиеФормы = "Документ.УведомлениеОПравеНаИмущественныйВычетДляНДФЛ.ФормаОбъекта";
	КонецЕсли;
	
	ПараметрыФормыДокумента.НаименованиеФормы = НаименованиеФормы;
	ПараметрыФормыДокумента.ПараметрыЗаполнения = ПараметрыЗаполнения;
		
	Возврат ПараметрыФормыДокумента;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПараметрыЗаполненияЛичныйВычет(ПараметрыЗаполнения)
	
	СуществующийДокумент = 
		Документы.ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛ.СуществующееЗаявлениеНаВычет(
			Задание.ФизическоеЛицо, НачалоМесяца(Объект.Дата));
	                                                                  
	Если СуществующийДокумент.Пустая() Тогда
		ДанныеЗаполнения = Новый Структура;
		ДанныеЗаполнения.Вставить("Действие", "ЗаполнитьПоПараметрамЗаполнения");
		ДанныеЗаполнения.Вставить("Сотрудник", Задание.ФизическоеЛицо);
		ДанныеЗаполнения.Вставить("Организация", Задание.Организация);
		ДанныеЗаполнения.Вставить("ИзменитьЛичныйВычет", Задание.ЛичныйВычет);
		ДанныеЗаполнения.Вставить("Дата", Объект.Дата);
		
		ПараметрыЗаполнения.Вставить("Основание", ДанныеЗаполнения);
	Иначе
		ПараметрыЗаполнения.Вставить("Ключ", СуществующийДокумент);		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыЗаполненияВычет(ПараметрыЗаполнения)
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Действие", "ЗаполнитьПоПараметрамЗаполнения");
	ДанныеЗаполнения.Вставить("Сотрудник", Задание.ФизическоеЛицо);
	ДанныеЗаполнения.Вставить("Организация", Задание.Организация);
	ДанныеЗаполнения.Вставить("Дата", Объект.Дата);
	
	ПараметрыЗаполнения.Вставить("Основание", ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьВидимостьКнопокДействий()
	
	БизнесПроцессыЗаявокСотрудниковФормы.УстановитьВидимостьКнопокДействий(ЭтотОбъект, Задание.ЗаявлениеНаВычет);
	
	Если Объект.Выполнена Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.СоздатьДокумент.Доступность = Элементы.СоздатьДокумент.Доступность И ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты");
	Элементы.Выполнено.Доступность = (НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты")) 
									 ИЛИ Элементы.Выполнено.Доступность;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПрисоединенныйФайл(ПрисоединенныйФайл)
	БизнесПроцессыЗаявокСотрудниковКлиент.ОткрытьПрисоединенныйФайл(ЭтотОбъект, ПрисоединенныйФайл);	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПрисоединенныйФайл()
	Модифицированность = Истина;
	ФайлОтвета = Неопределено;
	РасширениеФайлаОтветаБезТочки = "";
	ПредставлениеФайлаОтвета = "";
	АдресХранилищаФайлаОтвета = "";
КонецПроцедуры

&НаСервере
Процедура УстановитьВидВычета()
	Если Задание.ЛичныйВычет Тогда
		ВидВычета = НСтр("ru = 'Заявление на личный вычет';
						|en = 'Personal deduction application'");
	ИначеЕсли Задание.ВычетНаДетей Тогда
		ВидВычета = НСтр("ru = 'Заявление на вычет на детей';
						|en = 'Child-related deduction application'");	
	ИначеЕсли Задание.ВычетНаНедвижимость Тогда
		ВидВычета = НСтр("ru = 'Заявление на вычет на недвижимость';
						|en = 'Real estate deduction application'");
	ИначеЕсли Задание.ВычетНаЛечение Тогда
		ВидВычета = НСтр("ru = 'Заявление на вычет на лечение';
						|en = 'Healthcare deduction application'");
	ИначеЕсли Задание.ВычетНаОбучение Тогда
		ВидВычета = НСтр("ru = 'Заявление на вычет на обучение';
						|en = 'Education deduction application'");
	Иначе
		ВидВычета = НСтр("ru = 'Заявление на вычет на основании уведомления';
						|en = 'Notification-based deduction application'");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьФормуЗадачи()
	БизнесПроцессыЗаявокСотрудниковФормы.ИнициализироватьФормуЗадачи(ЭтотОбъект, Элементы.ЗаданиеЗаявлениеНаВычет);
	УстановитьВидимостьКнопокДействий();
КонецПроцедуры

#КонецОбласти

