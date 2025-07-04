#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Создание_ведомостей 

Функция СоздатьРеестрыПоДокументуПереводНаРаботуСКоронавирусом(ДокументПереводНаРаботуСКоронавирусом) Экспорт
	
	ОбщиеПараметрыЗаполнения = ОбщиеПараметрыЗаполнения(ДокументПереводНаРаботуСКоронавирусом, ДокументПереводНаРаботуСКоронавирусом.Организация);
	РеестрыПоДокументуПереводНаРаботуСКоронавирусом = Новый Массив;
	
	// Зарплата к выплате по документу
	СменыДокументаПереводНаРаботуСКоронавирусом = СменыДокументаПереводНаРаботуСКоронавирусом(ДокументПереводНаРаботуСКоронавирусом);
	
	// Уникальные сочетания ключевых полей будущих ведомостей
	ПоляКлючаРеестра = ПоляКлючаРеестра();
	КлючиРеестров = КлючиРеестров(СменыДокументаПереводНаРаботуСКоронавирусом, ПоляКлючаРеестра);
	Для Каждого ПолеКлючаВедомости Из ПоляКлючаРеестра Цикл
		СменыДокументаПереводНаРаботуСКоронавирусом.Индексы.Добавить(ПолеКлючаВедомости);
	КонецЦикла;
	
	// По каждому ключу создаем реестр
	Для Каждого КлючРеестра Из КлючиРеестров Цикл
				
		СменаРеестра = СменаРеестра(КлючРеестра, СменыДокументаПереводНаРаботуСКоронавирусом);
		
		Если СменаРеестра.Количество() = 0 Тогда
			Продолжить
		КонецЕсли;
		
		Реестр = НовыйРеестрПоКлючу(КлючРеестра, ОбщиеПараметрыЗаполнения, СменаРеестра.ВыгрузитьКолонку("Сотрудник"));
			
		РеестрыПоДокументуПереводНаРаботуСКоронавирусом.Добавить(Реестр);
		
	КонецЦикла;
	
	Возврат РеестрыПоДокументуПереводНаРаботуСКоронавирусом;
	
КонецФункции

Функция ОбщиеПараметрыЗаполнения(ДокументСсылка, Организация)
	
	ОбщиеПараметрыЗаполнения = Новый Структура;
	ОбщиеПараметрыЗаполнения.Вставить("Организация", Организация);
	
	НастройкиКадровогоУчета = КадровыйУчет.НастройкиКадровогоУчета();
	ОбщиеПараметрыЗаполнения.Вставить("ВидПособия", НастройкиКадровогоУчета.ПолучательСтимулирующихВыплатФСС);
	
	ИменаРеквизитовОрганизации = "РегистрационныйНомерФСС, КодПодчиненностиФСС, ОГРН";
	ЗначенияРеквизитовОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, ИменаРеквизитовОрганизации);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ОбщиеПараметрыЗаполнения, ЗначенияРеквизитовОрганизации, Истина);
	
	СведенияОПодписях = ПодписиДокументов.СведенияОПодписяхПоУмолчаниюДляОбъектаМетаданных(Метаданные.Документы.РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам, Организация);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ОбщиеПараметрыЗаполнения, СведенияОПодписях, Истина);
	
	ДатаПолученияСведений = ТекущаяДатаСеанса();
	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, ДатаПолученияСведений, "ТелОрганизации,АдресЭлектроннойПочтыОрганизации,ИННЮЛ,КППЮЛ,НаимЮЛПол");
	ОбщиеПараметрыЗаполнения.Вставить("ИНН", СведенияОбОрганизации.ИННЮЛ);
	ОбщиеПараметрыЗаполнения.Вставить("КПП", СведенияОбОрганизации.КППЮЛ);
	ОбщиеПараметрыЗаполнения.Вставить("НаименованиеСтрахователя", СведенияОбОрганизации.НаимЮЛПол);
	ОбщиеПараметрыЗаполнения.Вставить("ТелефонСоставителя", СведенияОбОрганизации.ТелОрганизации);
	ОбщиеПараметрыЗаполнения.Вставить("АдресЭлектроннойПочтыСоставителя", СведенияОбОрганизации.АдресЭлектроннойПочтыОрганизации);
	ОбщиеПараметрыЗаполнения.Вставить("ВОрганизацииВыявленКоронавирус", Документы.РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам.ВОрганизацииВыявленКоронавирус(Организация, ДатаПолученияСведений));
	ОбщиеПараметрыЗаполнения.Вставить("СостояниеРеестра", Перечисления.СостоянияРеестровФСС.ВРаботе);
	ОбщиеПараметрыЗаполнения.Вставить("ДокументОснование", ДокументСсылка);
	
	ЗаполняемыеЗначения = Новый Структура;
	ЗаполняемыеЗначения.Вставить("Организация");
	ЗаполняемыеЗначения.Вставить("Ответственный");
	ЗаполнитьЗначенияСвойств(ЗаполняемыеЗначения, ОбщиеПараметрыЗаполнения);
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения);
	ОбщиеПараметрыЗаполнения.Вставить("Ответственный", ЗаполняемыеЗначения.Ответственный);
	
	Возврат ОбщиеПараметрыЗаполнения;
	
КонецФункции

Функция СменыДокументаПереводНаРаботуСКоронавирусом(ДокументПереводНаРаботуСКоронавирусом)
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументПереводНаРаботуСКоронавирусом",ДокументПереводНаРаботуСКоронавирусом);
	Запрос.МенеджерВременныхТаблиц =  Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПереводНаРаботуСКоронавирусомСотрудники.ДатаНачала КАК НачалоПериода,
	|	ПереводНаРаботуСКоронавирусомСотрудники.ДатаОкончания КАК ОкончаниеПериода,
	|	ПереводНаРаботуСКоронавирусомСотрудники.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТСменыДокументаПереводНаРаботуСКоронавирусом
	|ИЗ
	|	Документ.ПереводНаРаботуСКоронавирусом.Сотрудники КАК ПереводНаРаботуСКоронавирусомСотрудники
	|ГДЕ
	|	ПереводНаРаботуСКоронавирусомСотрудники.Ссылка = &ДокументПереводНаРаботуСКоронавирусом
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НачалоПериода,
	|	ОкончаниеПериода,
	|	Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СменыДокументаПереводНаРаботуСКоронавирусом.Сотрудник КАК Сотрудник,
	|	СменыДокументаПереводНаРаботуСКоронавирусом.НачалоПериода КАК НачалоПериода,
	|	СменыДокументаПереводНаРаботуСКоронавирусом.ОкончаниеПериода КАК ОкончаниеПериода,
	|	РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам.Ссылка КАК Ссылка,
	|	РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам.Дата КАК ДатаРеестра
	|ПОМЕСТИТЬ ВТСозданныеРанееРеестры
	|ИЗ
	|	ВТСменыДокументаПереводНаРаботуСКоронавирусом КАК СменыДокументаПереводНаРаботуСКоронавирусом
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам КАК РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам
	|		ПО (РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам.ДокументОснование = &ДокументПереводНаРаботуСКоронавирусом)
	|			И (НЕ РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам.ПометкаУдаления)
	|			И (РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам.НачалоПериода = СменыДокументаПереводНаРаботуСКоронавирусом.НачалоПериода)
	|			И (РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам.ОкончаниеПериода = СменыДокументаПереводНаРаботуСКоронавирусом.ОкончаниеПериода)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам.Сотрудники КАК РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникамСотрудники
	|		ПО (РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам.Ссылка = РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникамСотрудники.Ссылка)
	|			И (РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникамСотрудники.Сотрудник = СменыДокументаПереводНаРаботуСКоронавирусом.Сотрудник)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СозданныеРанееРеестры.Сотрудник КАК Сотрудник,
	|	СозданныеРанееРеестры.НачалоПериода КАК НачалоПериода,
	|	СозданныеРанееРеестры.ОкончаниеПериода КАК ОкончаниеПериода,
	|	МАКСИМУМ(СозданныеРанееРеестры.ДатаРеестра) КАК ДатаРеестра
	|ПОМЕСТИТЬ ВТСозданныеРанееРеестрыСрез
	|ИЗ
	|	ВТСозданныеРанееРеестры КАК СозданныеРанееРеестры
	|
	|СГРУППИРОВАТЬ ПО
	|	СозданныеРанееРеестры.Сотрудник,
	|	СозданныеРанееРеестры.НачалоПериода,
	|	СозданныеРанееРеестры.ОкончаниеПериода
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СменыДокументаПереводНаРаботуСКоронавирусом.НачалоПериода КАК НачалоПериода,
	|	СменыДокументаПереводНаРаботуСКоронавирусом.ОкончаниеПериода КАК ОкончаниеПериода,
	|	СменыДокументаПереводНаРаботуСКоронавирусом.Сотрудник КАК Сотрудник,
	|	ЕСТЬNULL(СозданныеРанееРеестры.Ссылка, ЗНАЧЕНИЕ(Документ.РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам.ПустаяСсылка)) КАК РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам
	|ИЗ
	|	ВТСменыДокументаПереводНаРаботуСКоронавирусом КАК СменыДокументаПереводНаРаботуСКоронавирусом
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСозданныеРанееРеестрыСрез КАК СозданныеРанееРеестрыСрез
	|		ПО (СозданныеРанееРеестрыСрез.Сотрудник = СменыДокументаПереводНаРаботуСКоронавирусом.Сотрудник)
	|			И (СозданныеРанееРеестрыСрез.НачалоПериода = СменыДокументаПереводНаРаботуСКоронавирусом.НачалоПериода)
	|			И (СозданныеРанееРеестрыСрез.ОкончаниеПериода = СменыДокументаПереводНаРаботуСКоронавирусом.ОкончаниеПериода)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСозданныеРанееРеестры КАК СозданныеРанееРеестры
	|		ПО (СозданныеРанееРеестрыСрез.Сотрудник = СозданныеРанееРеестры.Сотрудник)
	|			И (СозданныеРанееРеестрыСрез.НачалоПериода = СозданныеРанееРеестры.НачалоПериода)
	|			И (СозданныеРанееРеестрыСрез.ОкончаниеПериода = СозданныеРанееРеестры.ОкончаниеПериода)
	|			И (СозданныеРанееРеестрыСрез.ДатаРеестра = СозданныеРанееРеестры.ДатаРеестра)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НачалоПериода,
	|	ОкончаниеПериода,
	|	Сотрудник";
	Смены = Запрос.Выполнить().Выгрузить();
	
	Возврат Смены;
КонецФункции

Функция ПоляКлючаРеестра()
	
	ПоляКлючаВедомости = Новый Массив;
	ПоляКлючаВедомости.Добавить("НачалоПериода");
	ПоляКлючаВедомости.Добавить("ОкончаниеПериода");
	Возврат ПоляКлючаВедомости
	
КонецФункции

Функция КлючиРеестров(Смены, ПоляКлючаРеестра)
	
	КолонкиКлючаРеестра = СтрСоединить(ПоляКлючаРеестра, ", ");
	КлючиРеестров = Смены.Скопировать(, КолонкиКлючаРеестра);
	КлючиРеестров.Свернуть(КолонкиКлючаРеестра);
	
	Возврат КлючиРеестров;
	
КонецФункции

Функция СменаРеестра(КлючРеестра, СменыДокументаПереводНаРаботуСКоронавирусом)
	
	ПоляОтбораСмен = ОбщегоНазначения.ВыгрузитьКолонку(КлючРеестра.Владелец().Колонки, "Имя");
	
	ПараметрыОтбораСмен = Новый Структура(СтрСоединить(ПоляОтбораСмен, ", "));
	ЗаполнитьЗначенияСвойств(ПараметрыОтбораСмен, КлючРеестра);
	ПараметрыОтбораСмен.Вставить("РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам",Документы.РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам.ПустаяСсылка());
	
	СменаРеестра = СменыДокументаПереводНаРаботуСКоронавирусом.Скопировать(ПараметрыОтбораСмен);
	
	Возврат СменаРеестра
	
КонецФункции

Функция НовыйРеестрПоКлючу(КлючВедомости, ОбщиеПараметрыЗаполнения, Сотрудники)
	
	ДокументМенеджер = Документы.РеестрСтимулирующихВыплатМедицинскимИСоциальнымРаботникам;
	
	Реестр = ДокументМенеджер.СоздатьДокумент();
	Реестр.УстановитьСсылкуНового(ДокументМенеджер.ПолучитьСсылку());
	
	ЗаполнитьЗначенияСвойств(Реестр, ОбщиеПараметрыЗаполнения);
	
	Реестр.Организация      = ОбщиеПараметрыЗаполнения.Организация;
	Реестр.НачалоПериода 	= КлючВедомости.НачалоПериода;
	Реестр.ОкончаниеПериода = КлючВедомости.ОкончаниеПериода;
	Реестр.МесяцНачисления  = НачалоМесяца(КлючВедомости.ОкончаниеПериода);
	Реестр.Дата             = КлючВедомости.ОкончаниеПериода;
	
	ДанныеПоСотрудникам = ДокументМенеджер.СведенияПоСотрудникамНаСервере(ОбщиеПараметрыЗаполнения.Организация, КлючВедомости.НачалоПериода, КлючВедомости.ОкончаниеПериода, Сотрудники, Ложь);
	СменыРаботСотрудниковСКоронавирусом = ДокументМенеджер.СменыРаботСотрудниковСКоронавирусом(ОбщиеПараметрыЗаполнения.Организация, КлючВедомости.НачалоПериода, КлючВедомости.ОкончаниеПериода, ОбщиеПараметрыЗаполнения.ВидПособия, Сотрудники);
	
	СтруктураПоиска = Новый Структура("Сотрудник, Должность, КатегорияПолучателя");
	
	Для каждого СтрокаКадровыхДанных Из ДанныеПоСотрудникам Цикл
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаКадровыхДанных);
		РабочееВремяСотрудника = СменыРаботСотрудниковСКоронавирусом.НайтиСтроки(СтруктураПоиска);
		Если РабочееВремяСотрудника.Количество() = 0 Тогда
			Продолжить;
		ИначеЕсли РабочееВремяСотрудника[0].ДнейКОплате = 0
			И РабочееВремяСотрудника[0].СменКОплате = 0 Тогда
			Продолжить;
		КонецЕсли;
		СтрокиСотрудника = Реестр.Сотрудники.НайтиСтроки(СтруктураПоиска);
		Если СтрокиСотрудника.Количество()>0 Тогда
			СтрокаТаблицы = СтрокиСотрудника[0];
		Иначе
			СтрокаТаблицы = Реестр.Сотрудники.Добавить();
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаКадровыхДанных);
		
		Если РабочееВремяСотрудника.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, РабочееВремяСотрудника[0]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Реестр;
	
КонецФункции

#КонецОбласти

#Область Сохранение_ведомостей 

Функция ПроверитьРеестры(Реестры) Экспорт
	
	Отказ = Ложь;
	Для Каждого Реестр Из Реестры Цикл
		Если Не Реестр.ПроверитьЗаполнение() Тогда
			Сообщения = ПолучитьСообщенияПользователю(Ложь);
			Для Каждого Сообщение Из Сообщения Цикл
				Сообщение.КлючДанных = Реестр.ПолучитьСсылкуНового();
			КонецЦикла;
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Не Отказ
	
КонецФункции

Процедура СохранитьРеестры(Реестры, РежимЗаписи)	Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Для Каждого Реестр Из Реестры Цикл
			Реестр.Записать(РежимЗаписи);
		КонецЦикла;	
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(
			НСтр(
				"ru = 'Создание реестров стимулирующих выплат.Сохранение и проведение реестров';
				|en = 'Generating incentive payments registers.Saving and posting registers'", 
				ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, , , 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		   
	    ВызватьИсключение;
	
	КонецПопытки;
	
КонецПроцедуры	

#КонецОбласти

#КонецОбласти

#КонецЕсли