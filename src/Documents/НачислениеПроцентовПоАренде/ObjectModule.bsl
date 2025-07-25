
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокументПередЗаполнением();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокументПередЗаполнением();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Истина, Отказ);
	
	ПроверитьДубли(Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	СформироватьЗаданияКЗакрытиюМесяцаПриПроведении();
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	СформироватьЗаданияКЗакрытиюМесяцаПриОтменеПроведения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокументПередЗаполнением()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

Процедура ПроверитьДубли(Отказ)

	Если НЕ ЗначениеЗаполнено(Организация) 
		ИЛИ НЕ ЗначениеЗаполнено(Дата) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДанныеДокумента.Ссылка
	|ИЗ
	|	Документ.НачислениеПроцентовПоАренде КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка <> &Ссылка
	|	И ДанныеДокумента.Проведен
	|	И ДанныеДокумента.Организация = &Организация
	|	И ДанныеДокумента.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|	И ДанныеДокумента.Дата МЕЖДУ &НачалоМесяца И &КонецМесяца";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("НачалоМесяца", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецМесяца", КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		ШаблонТекста = НСтр("ru = 'За %1 уже есть проведенный документ для выбранной организации.';
							|en = 'There already exists a posted document for the selected company for %1.'");
		ТекстСообщения = СтрШаблон(ШаблонТекста, Формат(Дата, НСтр("ru = 'ДФ=''ММММ гггг ""г.""''';
																	|en = 'DF=''MMMM yyyy'''")));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "НомерПакета",, Отказ); 
	КонецЕсли; 
	
КонецПроцедуры

Процедура СформироватьЗаданияКЗакрытиюМесяцаПриОтменеПроведения()

	Если ДополнительныеСвойства.Свойство("ОчисткаДляПоследующегоПроведения") 
		И ДополнительныеСвойства.ОчисткаДляПоследующегоПроведения Тогда
		Возврат;
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.НачислениеПроцентовПоАренде Тогда
		Если Документы.НачислениеПроцентовПоАренде.ТребуетсяНачислениеПроцентовПоАренде(НачалоМесяца(Дата), Организация) Тогда
			
			РегистрыСведений.ЗаданияКЗакрытиюМесяца.СоздатьЗаписьРегистра(
				НачалоМесяца(Дата), 
				Ссылка, 
				Организация, 
				Перечисления.ОперацииЗакрытияМесяца.НачислениеПроцентовПоАренде);
				
			КонецЕсли;
	Иначе
		Если Документы.НачислениеПроцентовПоАренде.ТребуетсяНачислениеПроцентовПоДоходнойАренде(НачалоМесяца(Дата), Организация, Ложь) Тогда
			
			РегистрыСведений.ЗаданияКЗакрытиюМесяца.СоздатьЗаписьРегистра(
				НачалоМесяца(Дата), 
				Ссылка, 
				Организация, 
				Перечисления.ОперацииЗакрытияМесяца.НачислениеПроцентовПоДоходнойАренде);
				
			КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

// Сформировать задания к закрытию месяца при проведении.
// Создает задания на следующий месяц.
Процедура СформироватьЗаданияКЗакрытиюМесяцаПриПроведении()
	
	НачалоСледующегоМесяца = ДобавитьМесяц(НачалоМесяца(Дата),1);
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.НачислениеПроцентовПоАренде Тогда
		Если Документы.НачислениеПроцентовПоАренде.ТребуетсяНачислениеПроцентовПоАренде(НачалоСледующегоМесяца, Организация) Тогда
			
			РегистрыСведений.ЗаданияКЗакрытиюМесяца.СоздатьЗаписьРегистра(
				НачалоСледующегоМесяца,
				Ссылка,
				Организация,
				Перечисления.ОперацииЗакрытияМесяца.НачислениеПроцентовПоАренде);
				
		КонецЕсли;
	Иначе
		Если Документы.НачислениеПроцентовПоАренде.ТребуетсяНачислениеПроцентовПоДоходнойАренде(НачалоСледующегоМесяца, Организация, Ложь) Тогда
			
			РегистрыСведений.ЗаданияКЗакрытиюМесяца.СоздатьЗаписьРегистра(
				НачалоСледующегоМесяца,
				Ссылка,
				Организация,
				Перечисления.ОперацииЗакрытияМесяца.НачислениеПроцентовПоДоходнойАренде);
				
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
