#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаписьКнигиПродаж") Тогда
		
		ХозяйственнаяОперация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения,  "ХозяйственнаяОперация");
		
		Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПрочееНачислениеНДС Тогда
			ВызватьИсключение НСтр("ru = 'Ввод возможен только на основании документа с операцией ""Прочее начисление НДС""';
									|en = 'You can enter it only based on the document with the ""Other VAT accrual"" transaction'");
		КонецЕсли;
		
		ЗаполнитьИсправлениеПрочегоНачисленияНДС(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ ЗаписьДополнительногоЛиста Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КорректируемыйПериод");
	КонецЕсли; 
	
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	
	Документы.ЗаписьКнигиПродаж.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	Для Каждого ЭлементМассива Из МассивВсехРеквизитов Цикл
		// Если реквизит не используется для хозяйственной операции, исключаем данный реквизит из проверки.
		Если МассивРеквизитовОперации.Найти(ЭлементМассива) = Неопределено Тогда
			МассивНепроверяемыхРеквизитов.Добавить(ЭлементМассива);
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	УчетНДСРФ.ПроверитьСовместимостьВидовЦенностейТабличнойЧасти(ЭтотОбъект, "Ценности", Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	СуммаДокумента = Ценности.Итог("Сумма") + Ценности.Итог("СуммаНДС");
	
	Если НЕ ЗначениеЗаполнено(ДокументРасчетов) И ДокументРасчетов <> Неопределено Тогда
		ДокументРасчетов = Неопределено
	КонецЕсли;
	
	Если НЕ ЗаписьДополнительногоЛиста И ЗначениеЗаполнено(КорректируемыйПериод) Тогда
		КорректируемыйПериод = '00010101'
	КонецЕсли;
	
	//++ НЕ УТ

	//Настройка счетов учета
	НастройкаСчетовУчетаСервер.ПередЗаписью(ЭтотОбъект,
		Документы.ЗаписьКнигиПродаж.ПараметрыНастройкиСчетовУчета(ХозяйственнаяОперация));
	//-- НЕ УТ
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Ценности,Расхождения");
		
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ИсправлениеПрочегоНачисленияНДС Тогда
		Расхождения.Очистить();
	КонецЕсли;
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Документы.ЗаписьКнигиПродаж.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
		
	ПараметрыРегистрации = Документы.ЗаписьКнигиПродаж.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления, Проведен);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(Отказ)
	
	СтруктураПересчетаСуммы = Новый Структура;
	СтруктураПересчетаСуммы.Вставить("ЦенаВключаетНДС", Ложь);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму", "Количество");
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Ценности, СтруктураДействий, Неопределено);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ПараметрыРегистрации = Документы.ЗаписьКнигиПродаж.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПриПроведении(ПараметрыРегистрации);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ПараметрыРегистрации = Документы.ЗаписьКнигиПродаж.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПриУдаленииПроведения(ПараметрыРегистрации);
	
КонецПроцедуры

#Область ЗаполнениеДокумента

Процедура ЗаполнитьИсправлениеПрочегоНачисленияНДС(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаписьКнигиПродаж.Организация      КАК Организация,
	|	ЗаписьКнигиПродаж.Контрагент       КАК Контрагент,
	|	ЗаписьКнигиПродаж.Валюта           КАК Валюта,
	|	ЗаписьКнигиПродаж.Грузоотправитель КАК Грузоотправитель,
	|	ЗаписьКнигиПродаж.Грузополучатель  КАК Грузополучатель,
	|	ЗаписьКнигиПродаж.Ссылка           КАК ИсправляемыйДокумент,
	|	ЗаписьКнигиПродаж.Руководитель     КАК Руководитель,
	|	ЗаписьКнигиПродаж.ГлавныйБухгалтер КАК ГлавныйБухгалтер,
	|	ЗаписьКнигиПродаж.Подразделение    КАК Подразделение,
	|	ЗаписьКнигиПродаж.КодВидаОперации  КАК КодВидаОперации,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИсправлениеПрочегоНачисленияНДС) КАК ХозяйственнаяОперация,
	|	ЗаписьКнигиПродаж.Ценности.(
	|		Номенклатура,
	|		ВидЦенности,
	|		Количество,
	|		КоличествоПоРНПТ,
	|		Цена,
	|		Сумма,
	|		СтавкаНДС,
	|		СуммаНДС,
	|		НомерГТД,
	|		КодТНВЭД,
	|		Событие,
	|		НаправлениеДеятельности,
	|		НастройкаСчетовУчета
	|	) КАК Ценности
	|ИЗ
	|	Документ.ЗаписьКнигиПродаж КАК ЗаписьКнигиПродаж
	|ГДЕ
	|	ЗаписьКнигиПродаж.Ссылка = &ДанныеЗаполнения
	|";
	
	Запрос.УстановитьПараметр("ДанныеЗаполнения", ДанныеЗаполнения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	Ценности.Загрузить(Выборка.Ценности.Выгрузить());
	
	Документы.ЗаписьКнигиПродаж.ЗаполнитьРасхождения(ЭтотОбъект);
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Подразделение) Тогда
		Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли