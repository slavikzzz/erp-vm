////////////////////////////////////////////////////////////////////////////////
// Подсистема "Облачные классификаторы".
// ОбщийМодуль.ОблачныеКлассификаторыСлужебныйВызовСервера.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область КлассификаторТНВЭД

// Получение разделов классификатора ТН ВЭД.
// Разделами являются элементы верхнего уровня иерархии.
//
// Параметры:
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьРазделыТНВЭДВФоне(УникальныйИдентификатор, ИдентификаторЗадания) Экспорт
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = 'Облачный классификатор ТН ВЭД. Получение разделов.';
								|en = 'Cloud FEACN classifier. Receiving sections.'");
	ИмяПроцедуры        = "ОблачныеКлассификаторы.ПолучитьРазделыТНВЭД";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, Неопределено, ПараметрыВыполнения);
	
КонецФункции

// Получение подчиненных элементов классификатора ТН ВЭД.
//
// Параметры:
//  Код                      - Строка                  - код, для которого необходимо получить подчиненные элементы.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьПодчиненныеЭлементыТНВЭДВФоне(Код, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = 'Облачный классификатор ТН ВЭД. Получение подчиненных.';
								|en = 'Cloud FEACN classifier. Receiving subordinates.'");
	ИмяПроцедуры        = "ОблачныеКлассификаторы.ПолучитьПодчиненныеЭлементыТНВЭД";
	
	ПараметрыПроцедуры = Новый Структура("Код", Код);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

// Получение элементов классификатора ТН ВЭД по строке поиска.
//
// Параметры:
//  СтрокаПоиска             - Строка                  - значение для поиска в данных классификатора.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ОбработатьПоисковыйЗапросТНВЭДВФоне(СтрокаПоиска, НомерСтраницы, УникальныйИдентификатор,
		ИдентификаторЗадания) Экспорт
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = 'Облачный классификатор ТН ВЭД. Получение подчиненных.';
								|en = 'Cloud FEACN classifier. Receiving subordinates.'");
	ИмяПроцедуры        = "ОблачныеКлассификаторы.ОбработатьПоисковыйЗапросТНВЭД";
	
	ПараметрыПроцедуры = Новый Структура("СтрокаПоиска, НомерСтраницы", СтрокаПоиска, НомерСтраницы);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

// Получение ветки элементов классификатора ТН ВЭД.
//
// Параметры:
//  Код                      - Строка                  - код, для которого необходимо получить ветку.
//   АдресКэша                - Строка                  - адрес временного хранилища формы.
//  РежимВыбораЭлемента      - Булево                  - признак открытия формы в режиме выбора.
//  УникальныйИдентификатор  - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания     - УникальныйИдентификатор - идентификатор задания.
//
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьВеткуТНВЭДВФоне(Код, АдресКэша, РежимВыбораЭлемента, УникальныйИдентификатор,
		ИдентификаторЗадания) Экспорт
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = 'Облачный классификатор ТН ВЭД. Получение части иерархии.';
								|en = 'Cloud FEACN classifier. Receiving a part of the hierarchy.'");
	ИмяПроцедуры        = "ОблачныеКлассификаторы.ПолучитьВеткуТНВЭД";
	
	Кэш = КэшИзВременногоХранилища(АдресКэша);
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("Код",                 Код);
	ПараметрыПроцедуры.Вставить("Кэш",                 Кэш);
	ПараметрыПроцедуры.Вставить("РежимВыбораЭлемента", РежимВыбораЭлемента);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

// Загрузка данных подобранных элементов классификатора ТН ВЭД в базу.
//
// Параметры: 
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ЗагрузитьВБазуДанныеТНВЭДВФоне(АдресКэша, ВыбранныеЭлементы, УникальныйИдентификатор,
		ИдентификаторЗадания, ОбновитьКэш) Экспорт
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = 'Облачный классификатор ТН ВЭД. Загрузка данных в базу.';
								|en = 'Cloud FEACN classifier. Importing data to the database.'");
	ИмяПроцедуры        = "ОблачныеКлассификаторы.ЗагрузитьВБазуДанныеТНВЭД";
	
	Кэш = КэшИзВременногоХранилища(АдресКэша);
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("Кэш",               Кэш);
	ПараметрыПроцедуры.Вставить("ВыбранныеЭлементы", ВыбранныеЭлементы);
	ПараметрыПроцедуры.Вставить("ОбновитьКэш",       ОбновитьКэш);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

// Проверка возможности использования онлайн-подбора из классификатора ТНВЭД
//
Функция ДоступенОнлайнПодборИзКлассификатораТНВЭД() Экспорт
	
	ИспользоватьСервисРаботаСНоменклатурой = ПолучитьФункциональнуюОпцию("ИспользоватьСервисРаботаСНоменклатурой");
	
	Если Не ИспользоватьСервисРаботаСНоменклатурой Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПоддержкаПодключена = ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	
	Если Не ПоддержкаПодключена Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Отказ = Ложь;
	
	ОписаниеПараметровЗапроса = ОблачныеКлассификаторыСлужебный.ОписаниеПараметровЗапросаРазделыТНВЭД();
	ОписаниеПараметровЗапроса.НаборПолей = РаботаСНоменклатуройСлужебный.НаборПолейСтандартный();
	ОписаниеПараметровЗапроса.КоличествоЗаписей = 1;
	
	ПараметрыКоманды = ОблачныеКлассификаторыСлужебный.ПараметрыЗапросаРазделыТНВЭД(ОписаниеПараметровЗапроса);
	ДанныеСервиса    = РаботаСНоменклатуройСлужебный.ВыполнитьКомандуСервиса(ПараметрыКоманды, Отказ);
	
	Если Отказ Тогда
		ПолучитьСообщенияПользователю(Истина);
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

#КонецОбласти

#Область КлассификаторОКПД2 

// Определяет, доступен ли ОКПД 2 для работы онлайн.
//
// Возвращаемое значение:
//  Булево - если доступен - Истина, иначе - Ложь.
//
Функция ДоступенОнлайнПодборИзОКПД2() Экспорт
	
	ИспользоватьСервисРаботаСНоменклатурой = ПолучитьФункциональнуюОпцию("ИспользоватьСервисРаботаСНоменклатурой");
	
	Если Не ИспользоватьСервисРаботаСНоменклатурой Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.БазоваяФункциональностьБИП") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
	ПоддержкаПодключена 
		= МодульИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	
	Если Не ПоддержкаПодключена Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Отказ = Ложь;
	ОписаниеПараметровЗапроса = ОблачныеКлассификаторыСлужебный.ОписаниеПараметровЗапросаОКПД2();
	ОписаниеПараметровЗапроса.НаборПолей = РаботаСНоменклатуройСлужебный.НаборПолейСтандартный();
	ОписаниеПараметровЗапроса.КоличествоЗаписей = 1;
	
	ПараметрыКоманды = ОблачныеКлассификаторыСлужебный.ПараметрыЗапросаРазделыОКПД2(ОписаниеПараметровЗапроса);
	
	ДанныеСервиса = РаботаСНоменклатуройСлужебный.ВыполнитьКомандуСервиса(ПараметрыКоманды, Отказ);
	
	Если Отказ Тогда
		ПолучитьСообщенияПользователю(Истина);
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

// Получение разделов классификатора.
// Разделами являются элементы верхнего уровня иерархии.
//
// Параметры:
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьРазделыОКПД2ВФоне(УникальныйИдентификатор, ИдентификаторЗадания) Экспорт
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = 'Облачный классификатор ОКПД 2. Получение разделов.';
								|en = 'Cloud RNCPA 2 classifier. Receiving sections.'");
	
	ИмяПроцедуры = "ОблачныеКлассификаторы.ПолучитьРазделыОКПД2";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, Неопределено, ПараметрыВыполнения);
	
КонецФункции

// Получение подчиненных элементов классификатора.
//
// Параметры:
//  Код                      - Строка                  - код, для которого необходимо получить подчиненные элементы.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьПодчиненныеЭлементыОКПД2ВФоне(Код, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = 'Облачный классификатор ОКПД 2. Получение подчиненных.';
								|en = 'Cloud RNCPA 2 classifier. Receiving subordinates.'");

	ИмяПроцедуры = "ОблачныеКлассификаторы.ПолучитьПодчиненныеЭлементыОКПД2";
	
	ПараметрыПроцедуры = Новый Структура("Код", Код);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

// Получение элементов классификатора по строке поиска.
//
// Параметры:
//  СтрокаПоиска             - Строка                  - значение для поиска в данных классификатора.
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ОбработатьПоисковыйЗапросОКПД2ВФоне(СтрокаПоиска, НомерСтраницы, УникальныйИдентификатор,
		ИдентификаторЗадания) Экспорт
		
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = 'Облачный классификатор ОКПД 2. Получение подчиненных.';
								|en = 'Cloud RNCPA 2 classifier. Receiving subordinates.'");
	
	ИмяПроцедуры = "ОблачныеКлассификаторы.ОбработатьПоисковыйЗапросОКПД2";
	
	ПараметрыПроцедуры = Новый Структура("СтрокаПоиска, НомерСтраницы", СтрокаПоиска, НомерСтраницы);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

// Получение ветки элементов классификатора.
//
// Параметры:
//  Код                      - Строка                  - код, для которого необходимо получить ветку.
//  АдресКэша                - Строка                  - адрес временного хранилища формы.
//  РежимВыбораЭлемента      - Булево                  - признак открытия формы в режиме выбора.
//  УникальныйИдентификатор  - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания     - УникальныйИдентификатор - идентификатор задания.
//
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ПолучитьВеткуОКПД2ВФоне(Код, АдресКэша, РежимВыбораЭлемента, УникальныйИдентификатор,
		ИдентификаторЗадания) Экспорт
		
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	НаименованиеЗадания = НСтр("ru = 'Облачный классификатор ОКПД 2. Получение части иерархии.';
								|en = 'Cloud RNCPA 2 classifier. Receiving a part of the hierarchy.'");
	
	ИмяПроцедуры = "ОблачныеКлассификаторы.ПолучитьВеткуОКПД2";
	
	Кэш = КэшИзВременногоХранилища(АдресКэша);
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("Код",                 Код);
	ПараметрыПроцедуры.Вставить("Кэш",                 Кэш);
	ПараметрыПроцедуры.Вставить("РежимВыбораЭлемента", РежимВыбораЭлемента);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

// Загрузка данных подобранных элементов классификатора в базу.
//
// Параметры: 
//  ПараметрыЗагрузки 		   	  - Структура - содержит параметры загрузки элементов классификатора.
//		Ключи:
//  		АдресКэша 		  	  - Строка - Если загрузка вызвана из режима поиска то адрес кэша результата поискового запроса, 
//								 		  иначе - адрес временного хранилища формы 	
//  		АдресОсновногоКэша 	  - Строка - Адрес временного хранилища формы. 
//			ВыбранныеЭлементы  	  - Массив - Идентификаторы элементов классификатора, отмеченных к загрузке.
//			ЗагружатьСИерархией	  - Булево - Признак того, что помимо элементов, помеченных к загрузке, в базу 
//												будут перенесены и все их предки.
//			ПереноситьПодчиненные - Булево - Признак того, что помимо элементов, помеченных к загрузке, в базу 
//												будут перенесены все их потомки.
//
//  УникальныйИдентификатор	 - УникальныйИдентификатор - уникальный идентификатор формы.
//  ИдентификаторЗадания	 - УникальныйИдентификатор - идентификатор задания.
// 
// Возвращаемое значение:
//  Структура - см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ЗагрузитьВБазуДанныеОКПД2ВФоне(ПараметрыЗагрузки, УникальныйИдентификатор,	
	ИдентификаторЗадания, ОбновитьКэш) Экспорт
		
	Если Не ОблачныеКлассификаторы.РаботаСОблачнымиКлассификаторамиРазрешена() Тогда
		ВызватьИсключение НСтр("ru = 'Нарушение прав доступа.';
								|en = 'Access violation.'");
	КонецЕсли;
	
	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	АдресКэша                = ПараметрыЗагрузки.АдресКэша;
	АдресДополнительногоКэша = ПараметрыЗагрузки.АдресДополнительногоКэша; 
	
	НаименованиеЗадания = НСтр("ru = 'Облачный классификатор ОКПД 2. Загрузка данных в базу.';
								|en = 'Cloud RNCPA 2 classifier. Importing data to the database.'");
	
	ИмяПроцедуры = "ОблачныеКлассификаторы.ЗагрузитьВБазуДанныеОКПД2";
	
	Кэш = КэшИзВременногоХранилища(АдресКэша);
	
	Если АдресКэша <> АдресДополнительногоКэша Тогда //загрузка происходит из режима списка
		ДополнительныйКэш = КэшИзВременногоХранилища(АдресДополнительногоКэша, Кэш);
	Иначе
		ДополнительныйКэш = Кэш;
	КонецЕсли;	
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("Кэш",                   Кэш);
	ПараметрыПроцедуры.Вставить("ДополнительныйКэш",     ДополнительныйКэш); 
	ПараметрыПроцедуры.Вставить("ВыбранныеЭлементы",     ПараметрыЗагрузки.ВыбранныеЭлементы);
	ПараметрыПроцедуры.Вставить("ОбновитьКэш",           ОбновитьКэш);
	ПараметрыПроцедуры.Вставить("ЗагружатьСИерархией",   ПараметрыЗагрузки.ЗагружатьСИерархией);
	ПараметрыПроцедуры.Вставить("ПереноситьПодчиненные", ПараметрыЗагрузки.ПереноситьПодчиненные);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Отмена выполнения регламентного задания.
//
// Параметры:
//  ИдентификаторЗадания - УникальныйИдентификатор - идентификатор задания.
//
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Функция КэшИзВременногоХранилища(АдресКэша, ЗначениеПоУмолчанию = Неопределено)
	
	Кэш = ЗначениеПоУмолчанию;
	Если ЭтоАдресВременногоХранилища(АдресКэша) Тогда
		Кэш = ПолучитьИзВременногоХранилища(АдресКэша);
	КонецЕсли;
	Возврат Кэш;
	
КонецФункции

#КонецОбласти